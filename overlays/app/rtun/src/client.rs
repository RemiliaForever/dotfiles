//! The client: the side whose services/network are exposed by the server.

use std::cell::Cell;
use std::io;
use std::net::SocketAddr;
use std::time::{Duration, Instant};

use anyhow::{bail, Context, Result};
use tokio::io::{copy_bidirectional_with_sizes, AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpStream;
use tokio::time::timeout;
use tracing::{debug, error_span, info, instrument, trace, warn, Instrument};

use crate::crypto::{handshake, MAX_PAYLOAD};
use crate::net::tune;
use crate::protocol::{write_header, CtrlMsg, CONN_CONTROL, CONN_DATA};
use crate::stats::{Bytes, Counted};
use crate::tunnel::Tunnel;
use crate::ClientArgs;

const MAX_BACKOFF: Duration = Duration::from_secs(30);
/// How long to wait for a target to accept. Without this a host that drops SYNs
/// would hang the origin for the OS connect timeout (~2 min on Linux).
const DIAL_TIMEOUT: Duration = Duration::from_secs(10);

pub struct Client {
    server: String,
    tunnels: Vec<Tunnel>,
    secret: String,
    keepalive_interval: u64,
    keepalive_count: u64,
    reconnect: bool,
}

impl Client {
    /// `clap` guarantees at least one `-R`, so this cannot fail.
    pub fn from_args(args: ClientArgs) -> Self {
        for t in &args.remotes {
            debug!("tunnel {t}");
        }
        Self {
            server: args.server,
            tunnels: args.remotes,
            secret: args.secret,
            keepalive_interval: args.keepalive_interval,
            keepalive_count: args.keepalive_count.max(1),
            reconnect: !args.no_reconnect,
        }
    }

    /// Connects, and reconnects with exponential backoff unless disabled.
    pub async fn run(&self) -> Result<()> {
        let mut backoff = Duration::from_secs(1);
        loop {
            debug!("connecting to {} (rtun {})", self.server, env!("CARGO_PKG_VERSION"));
            let mut connected = false;
            let result = self.session(&mut connected).await;
            match &result {
                Ok(()) => info!("connection closed"),
                Err(e) if self.reconnect => warn!("connection error: {e:#}"),
                // Returned instead, so `main` reports it once and exits non-zero.
                Err(_) => {}
            }
            if !self.reconnect {
                debug!("reconnect disabled, exiting");
                return result;
            }
            // Only repeated failures back off; a session that came up starts over.
            if connected {
                backoff = Duration::from_secs(1);
            }
            info!("reconnecting in {}s", backoff.as_secs());
            tokio::time::sleep(backoff).await;
            backoff = (backoff * 2).min(MAX_BACKOFF);
        }
    }

    /// Registers the tunnels, then serves stream requests. Sets `connected`
    /// once the server has accepted them.
    async fn session(&self, connected: &mut bool) -> Result<()> {
        let tcp = TcpStream::connect(&self.server)
            .await
            .with_context(|| format!("connect {}", self.server))?;
        let peer = tcp.peer_addr().context("peer address")?;
        tune(&tcp).context("tune socket")?;
        self.serve(tcp, peer, connected).await
    }

    #[instrument(name = "conn", level = "error", skip_all, fields(peer = %peer))]
    async fn serve(&self, tcp: TcpStream, peer: SocketAddr, connected: &mut bool) -> Result<()> {
        let mut cs = handshake(tcp, self.secret.as_bytes()).await.context("crypto handshake")?;
        write_header(&mut cs, CONN_CONTROL).await?;

        cs.write_u16(self.tunnels.len() as u16).await?;
        for t in &self.tunnels {
            t.write_to(&mut cs).await?;
        }
        cs.flush().await?;
        trace!("sent {} tunnel spec(s), waiting for the bind result", self.tunnels.len());

        if cs.read_u8().await? != 0 {
            bail!("server rejected tunnels (bind failure)");
        }
        *connected = true;
        info!("connected, {} tunnel(s) active", self.tunnels.len());

        let (mut rd, mut wr) = tokio::io::split(cs);
        // Both loops run on this task, so a Cell needs no lock.
        let last_recv = Cell::new(Instant::now());

        tokio::select! {
            r = self.dispatch_loop(&mut rd, &last_recv) => r,
            r = self.keepalive_loop(&mut wr, &last_recv) => r,
        }
    }

    /// Handles NewStream requests coming from the server.
    async fn dispatch_loop<R: AsyncReadExt + Unpin>(
        &self,
        rd: &mut R,
        last_recv: &Cell<Instant>,
    ) -> Result<()> {
        loop {
            let msg = CtrlMsg::read_from(rd).await?;
            last_recv.set(Instant::now());
            match msg {
                CtrlMsg::Pong => trace!("pong"),
                CtrlMsg::Ping => debug!("unexpected ping from the server"),
                CtrlMsg::NewStream { id, host, port } => {
                    // ERROR keeps the tag at every log level.
                    let span = error_span!("stream", id);
                    let (server, secret) = (self.server.clone(), self.secret.clone());
                    tokio::spawn(
                        async move {
                            if let Err(e) =
                                open_data_stream(&server, &secret, id, &host, port).await
                            {
                                warn!("{e:#}");
                            }
                        }
                        .instrument(span),
                    );
                }
            }
        }
    }

    /// Sends periodic pings and gives up after too many silent intervals.
    async fn keepalive_loop<W: AsyncWriteExt + Unpin>(
        &self,
        wr: &mut W,
        last_recv: &Cell<Instant>,
    ) -> Result<()> {
        if self.keepalive_interval == 0 {
            debug!("keepalive disabled");
            return std::future::pending().await;
        }
        let interval = Duration::from_secs(self.keepalive_interval);
        let deadline =
            Duration::from_secs(self.keepalive_interval.saturating_mul(self.keepalive_count));
        let mut tick = tokio::time::interval(interval);
        tick.tick().await; // consume the immediate first tick
        loop {
            tick.tick().await;
            trace!("ping");
            CtrlMsg::Ping.write_to(wr).await?;
            if last_recv.get().elapsed() > deadline {
                bail!("keepalive timeout");
            }
        }
    }
}

/// Opens a data connection, connects to the target, reports status, splices.
async fn open_data_stream(
    server: &str,
    secret: &str,
    id: u64,
    host: &str,
    port: u16,
) -> Result<()> {
    debug!("dialing {host}:{port}");
    let tcp = TcpStream::connect(server).await?;
    tune(&tcp)?;
    let mut data = handshake(tcp, secret.as_bytes()).await?;
    write_header(&mut data, CONN_DATA).await?;
    data.write_u64(id).await?;
    // Must reach the server before the dial below, which can take DIAL_TIMEOUT.
    data.flush().await?;
    trace!("data channel registered with the server");

    // A socket we cannot configure counts as unreachable, as does a slow one.
    let dialed = timeout(DIAL_TIMEOUT, TcpStream::connect((host, port)))
        .await
        .unwrap_or_else(|_| Err(io::Error::new(io::ErrorKind::TimedOut, "connect timed out")))
        .and_then(|t| tune(&t).map(|()| t));
    match dialed {
        Ok(mut target) => {
            data.write_u8(0).await?; // reached target
            data.flush().await?;
            // Counted so the totals survive a relay that ends in an error.
            let mut data = Counted::new(data);
            let r = copy_bidirectional_with_sizes(&mut data, &mut target, MAX_PAYLOAD, MAX_PAYLOAD)
                .await;
            let (up, down) = (Bytes(data.read), Bytes(data.written));
            match r {
                Ok(_) => debug!("closed, {up} up / {down} down"),
                Err(e) => debug!("relay ended after {up} up / {down} down: {e}"),
            }
        }
        Err(e) => {
            debug!("cannot reach {host}:{port}: {e}");
            data.write_u8(1).await?; // unreachable
            data.flush().await?;
        }
    }
    Ok(())
}
