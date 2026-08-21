//! The client: the side whose services/network are exposed by the server.

use std::sync::Arc;
use std::time::{Duration, Instant};

use anyhow::{bail, Context, Result};
use tokio::io::{copy_bidirectional, AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpStream;
use tokio::sync::Mutex;

use crate::crypto::handshake;
use crate::protocol::{write_header, CtrlMsg, CONN_CONTROL, CONN_DATA};
use crate::tunnel::Tunnel;
use crate::ClientArgs;

const MAX_BACKOFF: Duration = Duration::from_secs(30);

pub struct Client {
    server: String,
    tunnels: Vec<Tunnel>,
    secret: String,
    keepalive_interval: u64,
    keepalive_count: u64,
    reconnect: bool,
}

impl Client {
    pub fn from_args(args: ClientArgs) -> Result<Self> {
        if args.remotes.is_empty() {
            bail!("no -R tunnels specified");
        }
        let tunnels = args
            .remotes
            .iter()
            .map(|s| Tunnel::parse(s))
            .collect::<Result<_>>()?;
        Ok(Self {
            server: args.server,
            tunnels,
            secret: args.secret,
            keepalive_interval: args.keepalive_interval,
            keepalive_count: args.keepalive_count.max(1),
            reconnect: !args.no_reconnect,
        })
    }

    /// Connects, and reconnects with exponential backoff unless disabled.
    pub async fn run(&self) -> Result<()> {
        let mut backoff = Duration::from_secs(1);
        loop {
            match self.session().await {
                Ok(()) => eprintln!("connection closed"),
                Err(e) => eprintln!("connection error: {e:#}"),
            }
            if !self.reconnect {
                return Ok(());
            }
            eprintln!("reconnecting in {}s", backoff.as_secs());
            tokio::time::sleep(backoff).await;
            backoff = (backoff * 2).min(MAX_BACKOFF);
        }
    }

    /// One control connection: registers tunnels, then serves stream requests.
    async fn session(&self) -> Result<()> {
        let tcp = TcpStream::connect(&self.server)
            .await
            .with_context(|| format!("connect {}", self.server))?;
        let mut cs = handshake(tcp, self.secret.as_bytes())
            .await
            .context("crypto handshake")?;
        write_header(&mut cs, CONN_CONTROL).await?;

        cs.write_u16(self.tunnels.len() as u16).await?;
        for t in &self.tunnels {
            t.write_spec(&mut cs).await?;
        }
        cs.flush().await?;

        if cs.read_u8().await? != 0 {
            bail!("server rejected tunnels (bind failure)");
        }
        eprintln!("connected to {}, {} tunnel(s) active", self.server, self.tunnels.len());

        let (mut rd, mut wr) = tokio::io::split(cs);
        let last_recv = Arc::new(Mutex::new(Instant::now()));

        tokio::select! {
            r = self.dispatch_loop(&mut rd, &last_recv) => r,
            r = self.keepalive_loop(&mut wr, &last_recv) => r,
        }
    }

    /// Handles NewStream requests coming from the server.
    async fn dispatch_loop<R: AsyncReadExt + Unpin>(
        &self,
        rd: &mut R,
        last_recv: &Arc<Mutex<Instant>>,
    ) -> Result<()> {
        loop {
            let msg = CtrlMsg::read_from(rd).await?;
            *last_recv.lock().await = Instant::now();
            if let CtrlMsg::NewStream { id, host, port } = msg {
                let server = self.server.clone();
                let secret = self.secret.clone();
                tokio::spawn(async move {
                    if let Err(e) = open_data_stream(&server, &secret, id, &host, port).await {
                        eprintln!("stream {id} to {host}:{port} failed: {e:#}");
                    }
                });
            }
        }
    }

    /// Sends periodic pings and gives up after too many silent intervals.
    async fn keepalive_loop<W: AsyncWriteExt + Unpin>(
        &self,
        wr: &mut W,
        last_recv: &Arc<Mutex<Instant>>,
    ) -> Result<()> {
        if self.keepalive_interval == 0 {
            std::future::pending::<()>().await;
            return Ok(());
        }
        let interval = Duration::from_secs(self.keepalive_interval);
        let deadline =
            Duration::from_secs(self.keepalive_interval.saturating_mul(self.keepalive_count));
        let mut tick = tokio::time::interval(interval);
        tick.tick().await; // consume the immediate first tick
        loop {
            tick.tick().await;
            CtrlMsg::Ping.write_to(wr).await?;
            if last_recv.lock().await.elapsed() > deadline {
                bail!("keepalive timeout");
            }
        }
    }
}

/// Opens a data connection, connects to the target, reports status, splices.
async fn open_data_stream(server: &str, secret: &str, id: u64, host: &str, port: u16) -> Result<()> {
    let tcp = TcpStream::connect(server).await?;
    let mut data = handshake(tcp, secret.as_bytes()).await?;
    write_header(&mut data, CONN_DATA).await?;
    data.write_u64(id).await?;

    match TcpStream::connect((host, port)).await {
        Ok(mut target) => {
            data.write_u8(0).await?; // reached target
            data.flush().await?;
            copy_bidirectional(&mut data, &mut target).await.ok();
            Ok(())
        }
        Err(e) => {
            data.write_u8(1).await?; // unreachable
            data.flush().await?;
            Err(e.into())
        }
    }
}
