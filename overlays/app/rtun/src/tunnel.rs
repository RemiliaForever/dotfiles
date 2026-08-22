//! Reverse tunnel specifications (the `-R` flag).

use std::fmt;
use std::str::FromStr;

use anyhow::{bail, Context, Result};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

use crate::protocol::{read_string, write_bytes, TUN_FORWARD, TUN_SOCKS};

/// A single reverse tunnel requested by the client and bound by the server.
#[derive(Clone)]
pub enum Tunnel {
    /// Expose `host:host_port` (resolved on the client) at `bind_addr:bind_port`.
    Forward { bind_addr: String, bind_port: u16, host: String, host_port: u16 },
    /// Run a SOCKS5 proxy at `bind_addr:bind_port`, dialing from the client.
    Socks { bind_addr: String, bind_port: u16 },
}

impl FromStr for Tunnel {
    type Err = anyhow::Error;

    /// Parses an ssh-style `-R` spec:
    ///   `PORT` / `ADDR:PORT`                 → SOCKS
    ///   `PORT:HOST:HP` / `ADDR:PORT:HOST:HP` → forward
    fn from_str(spec: &str) -> Result<Tunnel> {
        let parts: Vec<&str> = spec.split(':').collect();
        let port = |s: &str| -> Result<u16> { s.parse().with_context(|| format!("bad port: {s}")) };
        match parts.as_slice() {
            [p] => Ok(Tunnel::Socks { bind_addr: "127.0.0.1".into(), bind_port: port(p)? }),
            [addr, p] => Ok(Tunnel::Socks { bind_addr: (*addr).into(), bind_port: port(p)? }),
            [p, host, hp] => Ok(Tunnel::Forward {
                bind_addr: "127.0.0.1".into(),
                bind_port: port(p)?,
                host: (*host).into(),
                host_port: port(hp)?,
            }),
            [addr, p, host, hp] => Ok(Tunnel::Forward {
                bind_addr: (*addr).into(),
                bind_port: port(p)?,
                host: (*host).into(),
                host_port: port(hp)?,
            }),
            _ => bail!("invalid -R spec: {spec}"),
        }
    }
}

impl fmt::Display for Tunnel {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{} ", self.bind_addr(), self.bind_port())?;
        match self {
            Tunnel::Forward { host, host_port, .. } => write!(f, "(forward -> {host}:{host_port})"),
            Tunnel::Socks { .. } => f.write_str("(socks)"),
        }
    }
}

impl Tunnel {
    pub fn bind_addr(&self) -> &str {
        match self {
            Tunnel::Forward { bind_addr, .. } | Tunnel::Socks { bind_addr, .. } => bind_addr,
        }
    }

    pub fn bind_port(&self) -> u16 {
        match self {
            Tunnel::Forward { bind_port, .. } | Tunnel::Socks { bind_port, .. } => *bind_port,
        }
    }

    pub async fn write_to<W: AsyncWriteExt + Unpin>(&self, w: &mut W) -> Result<()> {
        match self {
            Tunnel::Forward { bind_addr, bind_port, host, host_port } => {
                w.write_u8(TUN_FORWARD).await?;
                write_bytes(w, bind_addr.as_bytes()).await?;
                w.write_u16(*bind_port).await?;
                write_bytes(w, host.as_bytes()).await?;
                w.write_u16(*host_port).await?;
            }
            Tunnel::Socks { bind_addr, bind_port } => {
                w.write_u8(TUN_SOCKS).await?;
                write_bytes(w, bind_addr.as_bytes()).await?;
                w.write_u16(*bind_port).await?;
            }
        }
        Ok(())
    }

    pub async fn read_from<R: AsyncReadExt + Unpin>(r: &mut R) -> Result<Tunnel> {
        let kind = r.read_u8().await?;
        let bind_addr = read_string(r).await?;
        let bind_port = r.read_u16().await?;
        match kind {
            TUN_FORWARD => Ok(Tunnel::Forward {
                bind_addr,
                bind_port,
                host: read_string(r).await?,
                host_port: r.read_u16().await?,
            }),
            TUN_SOCKS => Ok(Tunnel::Socks { bind_addr, bind_port }),
            other => bail!("unknown tunnel kind {other}"),
        }
    }
}
