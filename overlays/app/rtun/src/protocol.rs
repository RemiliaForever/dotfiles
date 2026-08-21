//! On-the-wire protocol: constants, framing helpers and control messages.
//!
//! Everything here runs *inside* the encrypted stream (see [`crate::crypto`]),
//! so there is no plaintext framing to fingerprint.

use anyhow::{bail, Context, Result};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

/// Application protocol version, the first encrypted byte of every connection.
pub const VERSION: u8 = 1;

// Connection kinds (second encrypted byte).
pub const CONN_CONTROL: u8 = 1;
pub const CONN_DATA: u8 = 2;

// Control message tags.
const MSG_NEW_STREAM: u8 = 1;
const MSG_PING: u8 = 2;
const MSG_PONG: u8 = 3;

// Tunnel kinds, used by [`crate::tunnel::Tunnel`] specs.
pub const TUN_FORWARD: u8 = 1;
pub const TUN_SOCKS: u8 = 2;

/// Writes a `u16`-length-prefixed byte string.
pub async fn write_bytes<W: AsyncWriteExt + Unpin>(w: &mut W, buf: &[u8]) -> Result<()> {
    let len: u16 = buf.len().try_into().context("field too long")?;
    w.write_u16(len).await?;
    w.write_all(buf).await?;
    Ok(())
}

/// Reads a `u16`-length-prefixed byte string.
async fn read_bytes<R: AsyncReadExt + Unpin>(r: &mut R) -> Result<Vec<u8>> {
    let len = r.read_u16().await? as usize;
    let mut buf = vec![0u8; len];
    r.read_exact(&mut buf).await?;
    Ok(buf)
}

/// Reads a length-prefixed UTF-8 string.
pub async fn read_string<R: AsyncReadExt + Unpin>(r: &mut R) -> Result<String> {
    Ok(String::from_utf8(read_bytes(r).await?)?)
}

/// Writes the two-byte application header (as a single frame).
pub async fn write_header<W: AsyncWriteExt + Unpin>(w: &mut W, conn_type: u8) -> Result<()> {
    w.write_all(&[VERSION, conn_type]).await?;
    Ok(())
}

/// Reads the application header, returning the connection kind byte.
pub async fn read_header<R: AsyncReadExt + Unpin>(r: &mut R) -> Result<u8> {
    let version = r.read_u8().await?;
    if version != VERSION {
        bail!("unsupported protocol version {version}");
    }
    Ok(r.read_u8().await?)
}

/// A message on the control channel, in either direction.
pub enum CtrlMsg {
    /// Server asks the client to open a data stream to `host:port`.
    NewStream { id: u64, host: String, port: u16 },
    /// Client keepalive.
    Ping,
    /// Server keepalive response.
    Pong,
}

impl CtrlMsg {
    pub async fn write_to<W: AsyncWriteExt + Unpin>(&self, w: &mut W) -> Result<()> {
        match self {
            CtrlMsg::NewStream { id, host, port } => {
                w.write_u8(MSG_NEW_STREAM).await?;
                w.write_u64(*id).await?;
                write_bytes(w, host.as_bytes()).await?;
                w.write_u16(*port).await?;
            }
            CtrlMsg::Ping => w.write_u8(MSG_PING).await?,
            CtrlMsg::Pong => w.write_u8(MSG_PONG).await?,
        }
        w.flush().await?;
        Ok(())
    }

    pub async fn read_from<R: AsyncReadExt + Unpin>(r: &mut R) -> Result<CtrlMsg> {
        match r.read_u8().await? {
            MSG_NEW_STREAM => {
                let id = r.read_u64().await?;
                let host = read_string(r).await?;
                let port = r.read_u16().await?;
                Ok(CtrlMsg::NewStream { id, host, port })
            }
            MSG_PING => Ok(CtrlMsg::Ping),
            MSG_PONG => Ok(CtrlMsg::Pong),
            other => bail!("unknown control message {other}"),
        }
    }
}
