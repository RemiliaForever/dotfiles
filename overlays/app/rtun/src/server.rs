//! The server: exposes bound ports and relays their traffic to the client.

use std::collections::HashMap;
use std::net::SocketAddr;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::Duration;

use anyhow::{bail, Context, Result};
use tokio::io::{copy_bidirectional, AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};
use tokio::sync::{mpsc, oneshot, Mutex};
use tokio::task::JoinHandle;

use crate::crypto::{handshake, Enc};
use crate::protocol::{read_header, CtrlMsg, CONN_CONTROL, CONN_DATA};
use crate::socks;
use crate::tunnel::Tunnel;

/// How long an accepted connection waits for its matching data channel.
const STREAM_TIMEOUT: Duration = Duration::from_secs(15);

/// Shared server state. Data connections arrive independently of control
/// connections, so the pending-stream registry lives here, keyed globally.
pub struct Server {
    secret: String,
    pending: Mutex<HashMap<u64, oneshot::Sender<Enc>>>,
    next_id: AtomicU64,
}

impl Server {
    pub fn new(secret: String) -> Arc<Self> {
        Arc::new(Self {
            secret,
            pending: Mutex::new(HashMap::new()),
            next_id: AtomicU64::new(1),
        })
    }

    pub async fn run(self: Arc<Self>, listen: &str) -> Result<()> {
        let listener = TcpListener::bind(listen)
            .await
            .with_context(|| format!("bind {listen}"))?;
        eprintln!("rtun server listening on {listen}");
        loop {
            let (tcp, peer) = match listener.accept().await {
                Ok(v) => v,
                Err(e) => {
                    // A per-connection error (e.g. fd exhaustion) must not kill
                    // the server; log, back off briefly and keep serving.
                    eprintln!("accept failed: {e}");
                    tokio::time::sleep(Duration::from_millis(100)).await;
                    continue;
                }
            };
            let server = self.clone();
            tokio::spawn(async move {
                if let Err(e) = server.serve_conn(tcp, peer).await {
                    eprintln!("connection from {peer} ended: {e:#}");
                }
            });
        }
    }

    async fn serve_conn(self: Arc<Self>, tcp: TcpStream, peer: SocketAddr) -> Result<()> {
        let mut cs = handshake(tcp, self.secret.as_bytes())
            .await
            .context("crypto handshake")?;
        match read_header(&mut cs).await? {
            CONN_CONTROL => ControlSession::new(self, peer).run(cs).await,
            CONN_DATA => self.serve_data(cs).await,
            other => bail!("unknown connection type {other}"),
        }
    }

    /// A data connection: hand it to the accept task waiting on this stream id.
    async fn serve_data(&self, mut cs: Enc) -> Result<()> {
        let id = cs.read_u64().await?;
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

/// One client's control connection and the listeners bound on its behalf.
struct ControlSession {
    server: Arc<Server>,
    peer: SocketAddr,
}

impl ControlSession {
    fn new(server: Arc<Server>, peer: SocketAddr) -> Self {
        Self { server, peer }
    }

    async fn run(self, cs: Enc) -> Result<()> {
        let (mut rd, mut wr) = tokio::io::split(cs);

        // Read the requested tunnels.
        let count = rd.read_u16().await?;
        let mut tunnels = Vec::with_capacity(count as usize);
        for _ in 0..count {
            tunnels.push(Tunnel::read_spec(&mut rd).await?);
        }

        // Bind every listener up front; any failure aborts the client
        // (equivalent to ssh's ExitOnForwardFailure).
        let mut listeners = Vec::new();
        for t in &tunnels {
            let addr = format!("{}:{}", t.bind_addr(), t.bind_port());
            match TcpListener::bind(&addr).await {
                Ok(l) => listeners.push((l, t.clone())),
                Err(e) => {
                    eprintln!("[{}] failed to bind {addr}: {e}", self.peer);
                    wr.write_u8(1).await?;
                    wr.flush().await?;
                    return Ok(());
                }
            }
        }
        wr.write_u8(0).await?;
        wr.flush().await?;
        for (_, t) in &listeners {
            eprintln!("[{}] bound {}:{} ({})", self.peer, t.bind_addr(), t.bind_port(), t.describe());
        }

        // The writer task is the sole writer of the control connection.
        let (tx, rx) = mpsc::channel::<CtrlMsg>(64);
        let writer = tokio::spawn(control_writer(wr, rx));

        let accept_tasks: Vec<JoinHandle<()>> = listeners
            .into_iter()
            .map(|(listener, tunnel)| {
                tokio::spawn(accept_loop(self.server.clone(), listener, tunnel, tx.clone()))
            })
            .collect();

        // Answer pings until the client disconnects.
        while let Ok(msg) = CtrlMsg::read_from(&mut rd).await {
            if matches!(msg, CtrlMsg::Ping) && tx.send(CtrlMsg::Pong).await.is_err() {
                break;
            }
        }

        for task in &accept_tasks {
            task.abort();
        }
        drop(tx);
        writer.abort();
        eprintln!("[{}] control connection closed", self.peer);
        Ok(())
    }
}

/// Drains control messages onto the (encrypted) control connection.
async fn control_writer<W: AsyncWriteExt + Unpin>(mut wr: W, mut rx: mpsc::Receiver<CtrlMsg>) {
    while let Some(msg) = rx.recv().await {
        if msg.write_to(&mut wr).await.is_err() {
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
        let origin = match listener.accept().await {
            Ok((s, _)) => s,
            Err(_) => break,
        };
        let server = server.clone();
        let tunnel = tunnel.clone();
        let tx = tx.clone();
        tokio::spawn(async move {
            if let Err(e) = relay(server, tunnel, tx, origin).await {
                eprintln!("stream error: {e:#}");
            }
        });
    }
}

/// Determines the target, requests a data channel, then splices origin <-> data.
async fn relay(
    server: Arc<Server>,
    tunnel: Tunnel,
    tx: mpsc::Sender<CtrlMsg>,
    mut origin: TcpStream,
) -> Result<()> {
    let is_socks = tunnel.is_socks();
    let (host, port) = match &tunnel {
        Tunnel::Socks { .. } => match socks::negotiate(&mut origin).await {
            Ok(target) => target,
            Err(e) => {
                let _ = socks::reply(&mut origin, false).await;
                return Err(e);
            }
        },
        Tunnel::Forward { host, host_port, .. } => (host.clone(), *host_port),
    };

    let id = server.alloc_id();
    let (otx, orx) = oneshot::channel::<Enc>();
    server.register(id, otx).await;

    if tx.send(CtrlMsg::NewStream { id, host, port }).await.is_err() {
        server.forget(id).await;
        bail!("control channel gone");
    }

    let mut data = match tokio::time::timeout(STREAM_TIMEOUT, orx).await {
        Ok(Ok(s)) => s,
        _ => {
            server.forget(id).await;
            if is_socks {
                let _ = socks::reply(&mut origin, false).await;
            }
            bail!("timed out waiting for data channel {id}");
        }
    };

    // The client reports whether it reached the target.
    let ok = data.read_u8().await? == 0;
    if is_socks {
        socks::reply(&mut origin, ok).await?;
    }
    if !ok {
        bail!("client could not reach target for stream {id}");
    }

    copy_bidirectional(&mut origin, &mut data).await.ok();
    Ok(())
}
