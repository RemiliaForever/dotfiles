//! Minimal server-side SOCKS5 (CONNECT only). The outbound connection is not
//! made here — the requested target is relayed to the client, which dials it.

use anyhow::{bail, Result};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpStream;

/// Negotiates a SOCKS5 CONNECT and returns the requested `(host, port)`.
pub async fn negotiate(s: &mut TcpStream) -> Result<(String, u16)> {
    if s.read_u8().await? != 0x05 {
        bail!("not socks5");
    }
    let nmethods = s.read_u8().await?;
    let mut methods = vec![0u8; nmethods as usize];
    s.read_exact(&mut methods).await?;
    // We only support "no authentication"; reject clients that don't offer it.
    if !methods.contains(&0x00) {
        s.write_all(&[0x05, 0xFF]).await?;
        bail!("client offered no acceptable socks auth method");
    }
    s.write_all(&[0x05, 0x00]).await?;

    let ver = s.read_u8().await?;
    let cmd = s.read_u8().await?;
    let _rsv = s.read_u8().await?;
    let atyp = s.read_u8().await?;
    if ver != 0x05 || cmd != 0x01 {
        bail!("unsupported socks command {cmd}");
    }
    let host = match atyp {
        0x01 => {
            let mut a = [0u8; 4];
            s.read_exact(&mut a).await?;
            format!("{}.{}.{}.{}", a[0], a[1], a[2], a[3])
        }
        0x03 => {
            let len = s.read_u8().await? as usize;
            let mut buf = vec![0u8; len];
            s.read_exact(&mut buf).await?;
            String::from_utf8(buf)?
        }
        0x04 => {
            let mut a = [0u8; 16];
            s.read_exact(&mut a).await?;
            // No brackets: the client dials via `connect((host, port))`, which
            // resolves a bare IPv6 literal but not a bracketed one.
            std::net::Ipv6Addr::from(a).to_string()
        }
        other => bail!("unsupported socks atyp {other}"),
    };
    let port = s.read_u16().await?;
    Ok((host, port))
}

/// Sends the SOCKS5 reply (success or general failure).
pub async fn reply(s: &mut TcpStream, ok: bool) -> Result<()> {
    let rep = if ok { 0x00 } else { 0x01 };
    s.write_all(&[0x05, rep, 0x00, 0x01, 0, 0, 0, 0, 0, 0]).await?;
    Ok(())
}
