//! The server: exposes bound ports and relays their traffic to the client.

use std::collections::HashMap;
use std::net::SocketAddr;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::Duration;

use anyhow::{bail, Context, Result};
use tokio::io::{copy_bidirectional_with_sizes, AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};
use tokio::sync::{mpsc, oneshot, Mutex};
use tokio::task::JoinSet;
use tokio::time::timeout;
use tracing::{debug, error_span, info, instrument, trace, warn, Instrument, Span};

use crate::crypto::{handshake, Enc, MAX_PAYLOAD};
use crate::net::tune;
use crate::protocol::{read_header, CtrlMsg, CONN_CONTROL, CONN_DATA};
use crate::socks;
use crate::stats::{Bytes, Counted};
use crate::tunnel::Tunnel;

/// How long an accepted connection waits for its matching data channel.
const STREAM_TIMEOUT: Duration = Duration::from_secs(15);
/// How long a peer that has not yet proven it holds the PSK may pin a task and
/// an fd. Also bounds the SOCKS negotiation.
const HANDSHAKE_TIMEOUT: Duration = Duration::from_secs(10);

/// Shared server state. Data connections arrive independently of control
/// connections, so the pending-stream registry lives here, keyed globally.
pub struct Server {
    secret: String,
    pending: Mutex<HashMap<u64, oneshot::Sender<Enc>>>,
    next_id: AtomicU64,
}

impl Server {
    pub fn new(secret: String) -> Arc<Self> {
        Arc::new(Self { secret, pending: Mutex::new(HashMap::new()), next_id: AtomicU64::new(1) })
    }

    pub async fn run(self: Arc<Self>, listen: &str) -> Result<()> {
        let listener = TcpListener::bind(listen).await.with_context(|| format!("bind {listen}"))?;
        info!("listening on {listen} (rtun {})", env!("CARGO_PKG_VERSION"));
        loop {
            let (tcp, peer) = match listener.accept().await {
                Ok(v) => v,
                Err(e) => {
                    // One bad accept (e.g. fd exhaustion) must not kill the server.
                    warn!("accept failed: {e}");
                    tokio::time::sleep(Duration::from_millis(100)).await;
                    continue;
                }
            };
            tokio::spawn(self.clone().serve_conn(tcp, peer));
        }
    }

    /// One accepted connection; errors are logged, never propagated.
    #[instrument(name = "conn", level = "error", skip_all, fields(peer = %peer))]
    async fn serve_conn(self: Arc<Self>, tcp: TcpStream, peer: SocketAddr) {
        trace!("connection accepted");
        if let Err(e) = self.handle_conn(tcp).await {
            warn!("{e:#}");
        }
    }

    async fn handle_conn(self: Arc<Self>, tcp: TcpStream) -> Result<()> {
        tune(&tcp).context("tune socket")?;
        let (cs, kind) = timeout(HANDSHAKE_TIMEOUT, async {
            let mut cs =
                handshake(tcp, self.secret.as_bytes()).await.context("crypto handshake")?;
            trace!("handshake done");
            let kind = read_header(&mut cs).await?;
            anyhow::Ok((cs, kind))
        })
        .await
        .context("handshake timed out")??;
        trace!("connection kind {kind}");
        match kind {
            CONN_CONTROL => control_session(self, cs).await,
            CONN_DATA => self.serve_data(cs).await,
            other => bail!("unknown connection type {other}"),
        }
    }

    /// A data connection: hand it to the accept task waiting on this stream id.
    async fn serve_data(&self, mut cs: Enc) -> Result<()> {
        let id =
            timeout(HANDSHAKE_TIMEOUT, cs.read_u64()).await.context("stream id timed out")??;
        trace!("data channel for stream {id}");
        match self.pending.lock().await.remove(&id) {
            Some(tx) => {
                let _ = tx.send(cs);
                Ok(())
            }
            None => bail!("no pending stream {id}"),
        }
    }

    fn alloc_id(&self) -> u64 {
        self.next_id.fetch_add(1, Ordering::Relaxed)
    }

    async fn register(&self, id: u64, tx: oneshot::Sender<Enc>) {
        self.pending.lock().await.insert(id, tx);
    }

    async fn forget(&self, id: u64) {
        self.pending.lock().await.remove(&id);
    }
}

/// Binds the listeners one client asks for, then answers its keepalives.
async fn control_session(server: Arc<Server>, cs: Enc) -> Result<()> {
    let (mut rd, mut wr) = tokio::io::split(cs);

    let count = rd.read_u16().await?;
    debug!("client requested {count} tunnel(s)");
    let mut tunnels = Vec::with_capacity(count as usize);
    for _ in 0..count {
        let tunnel = Tunnel::read_from(&mut rd).await?;
        trace!("spec {tunnel}");
        tunnels.push(tunnel);
    }

    // Any bind failure aborts the client, like ssh's ExitOnForwardFailure.
    let mut listeners = Vec::new();
    for t in &tunnels {
        match TcpListener::bind((t.bind_addr(), t.bind_port())).await {
            Ok(l) => listeners.push((l, t.clone())),
            Err(e) => {
                warn!("cannot bind {t}: {e}");
                wr.write_u8(1).await?;
                wr.flush().await?;
                return Ok(());
            }
        }
    }
    wr.write_u8(0).await?;
    wr.flush().await?;
    for (_, t) in &listeners {
        info!("bound {t}");
    }

    // One writer task owns the control connection. Dropping the set aborts every
    // task in it, so no exit path can leave a listener bound. Instrumenting keeps
    // the session span, which is not current once a task is first polled.
    let (tx, rx) = mpsc::channel::<CtrlMsg>(64);
    let mut tasks = JoinSet::new();
    tasks.spawn(control_writer(wr, rx).instrument(Span::current()));
    for (listener, tunnel) in listeners {
        let loop_fut = accept_loop(server.clone(), listener, tunnel, tx.clone());
        tasks.spawn(loop_fut.instrument(Span::current()));
    }

    loop {
        match CtrlMsg::read_from(&mut rd).await {
            Ok(CtrlMsg::Ping) => {
                trace!("ping, answering pong");
                if tx.send(CtrlMsg::Pong).await.is_err() {
                    debug!("control writer gone, ending session");
                    break;
                }
            }
            Ok(_) => {} // the client sends nothing else
            Err(e) => {
                debug!("control read ended: {e:#}");
                break;
            }
        }
    }

    info!("control connection closed");
    Ok(())
}

/// Drains control messages onto the (encrypted) control connection.
async fn control_writer<W: AsyncWriteExt + Unpin>(mut wr: W, mut rx: mpsc::Receiver<CtrlMsg>) {
    while let Some(msg) = rx.recv().await {
        if let Err(e) = msg.write_to(&mut wr).await {
            debug!("control write failed: {e}");
            break;
        }
    }
}

/// Accepts connections on one bound port and spawns a relay for each.
async fn accept_loop(
    server: Arc<Server>,
    listener: TcpListener,
    tunnel: Tunnel,
    tx: mpsc::Sender<CtrlMsg>,
) {
    loop {
        let (origin, peer) = match listener.accept().await {
            Ok(v) => v,
            Err(e) => {
                // Transient; breaking would silently kill this tunnel.
                warn!("accept failed on {tunnel}: {e}");
                tokio::time::sleep(Duration::from_millis(100)).await;
                continue;
            }
        };
        // `#[instrument]` would build the span on first poll, when this session's
        // span is no longer current. ERROR keeps the tag at every log level.
        let id = server.alloc_id();
        let span = error_span!("stream", id);
        let (server, tunnel, tx) = (server.clone(), tunnel.clone(), tx.clone());
        tokio::spawn(
            async move {
                trace!("accepted from {peer}");
                if let Err(e) = relay(server, tunnel, tx, origin, peer, id).await {
                    warn!("{e:#}");
                }
            }
            .instrument(span),
        );
    }
}

/// Determines the target, requests a data channel, then splices origin <-> data.
async fn relay(
    server: Arc<Server>,
    tunnel: Tunnel,
    tx: mpsc::Sender<CtrlMsg>,
    mut origin: TcpStream,
    peer: SocketAddr,
    id: u64,
) -> Result<()> {
    tune(&origin).context("tune socket")?;
    let (host, port, is_socks) = match &tunnel {
        Tunnel::Socks { .. } => match timeout(HANDSHAKE_TIMEOUT, socks::negotiate(&mut origin))
            .await
            .context("socks handshake timed out")
            .and_then(|r| r)
        {
            Ok((host, port)) => (host, port, true),
            Err(e) => {
                let _ = socks::reply(&mut origin, false).await;
                debug!("socks handshake with {peer} failed: {e:#}");
                return Ok(());
            }
        },
        Tunnel::Forward { host, host_port, .. } => (host.clone(), *host_port, false),
    };
    debug!("{peer} -> {host}:{port}");

    let (otx, orx) = oneshot::channel::<Enc>();
    server.register(id, otx).await;
    trace!("asking the client for a data channel");

    if tx.send(CtrlMsg::NewStream { id, host: host.clone(), port }).await.is_err() {
        server.forget(id).await;
        bail!("control channel gone");
    }

    let mut data = match timeout(STREAM_TIMEOUT, orx).await {
        Ok(Ok(s)) => s,
        _ => {
            server.forget(id).await;
            if is_socks {
                let _ = socks::reply(&mut origin, false).await;
            }
            bail!("timed out waiting for data channel");
        }
    };

    trace!("data channel attached");

    // However this fails, the origin's request still has to be answered.
    let status = timeout(STREAM_TIMEOUT, data.read_u8())
        .await
        .context("client never reported target status")
        .and_then(|r| r.context("read target status"));
    let ok = match status {
        Ok(byte) => byte == 0,
        Err(e) => {
            if is_socks {
                let _ = socks::reply(&mut origin, false).await;
            }
            return Err(e);
        }
    };
    trace!("client reports reachable={ok}");
    if is_socks {
        socks::reply(&mut origin, ok).await?;
    }
    if !ok {
        debug!("client could not reach {host}:{port}");
        return Ok(());
    }

    // Counted so the totals survive a relay that ends in an error.
    let mut origin = Counted::new(origin);
    let r = copy_bidirectional_with_sizes(&mut origin, &mut data, MAX_PAYLOAD, MAX_PAYLOAD).await;
    let (up, down) = (Bytes(origin.read), Bytes(origin.written));
    match r {
        Ok(_) => debug!("closed, {up} up / {down} down"),
        Err(e) => debug!("relay ended after {up} up / {down} down: {e}"),
    }
    Ok(())
}
