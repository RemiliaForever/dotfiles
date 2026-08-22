//! Socket setup shared by both roles.

use std::io;
use std::time::Duration;

use socket2::{SockRef, TcpKeepalive};
use tokio::net::TcpStream;

/// Neither side writes on an idle connection, so a peer that vanishes without a
/// FIN is invisible at the application layer: the server would hold its
/// listeners, and the client its relays, forever. Kernel probes start after this
/// much silence and are retried below, detecting it in about a minute.
const KEEPALIVE_IDLE: Duration = Duration::from_secs(30);
const KEEPALIVE_INTERVAL: Duration = Duration::from_secs(10);
const KEEPALIVE_RETRIES: u32 = 3;

/// Disables Nagle, which would sit on the small framed writes, and arms TCP
/// keepalive.
pub fn tune(tcp: &TcpStream) -> io::Result<()> {
    tcp.set_nodelay(true)?;
    let keepalive = TcpKeepalive::new()
        .with_time(KEEPALIVE_IDLE)
        .with_interval(KEEPALIVE_INTERVAL)
        .with_retries(KEEPALIVE_RETRIES);
    SockRef::from(tcp).set_tcp_keepalive(&keepalive)
}
