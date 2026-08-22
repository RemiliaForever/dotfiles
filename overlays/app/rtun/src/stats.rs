//! Traffic accounting: human-readable byte counts and a metering stream.

use std::pin::Pin;
use std::task::{Context, Poll};
use std::{fmt, io};

use tokio::io::{AsyncRead, AsyncWrite, ReadBuf};

/// A byte count in the largest unit that keeps it at or above 1.
pub struct Bytes(pub u64);

impl fmt::Display for Bytes {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        const UNITS: [&str; 5] = ["B", "KiB", "MiB", "GiB", "TiB"];
        let mut n = self.0 as f64;
        let mut unit = 0;
        while n >= 1024.0 && unit + 1 < UNITS.len() {
            n /= 1024.0;
            unit += 1;
        }
        match unit {
            0 => write!(f, "{} B", self.0),
            _ => write!(f, "{n:.1} {}", UNITS[unit]),
        }
    }
}

/// Counts the bytes passing through a stream. `copy_bidirectional` reports its
/// totals only on success, so wrapping one side keeps them on the error path too.
pub struct Counted<S> {
    inner: S,
    pub read: u64,
    pub written: u64,
}

impl<S> Counted<S> {
    pub fn new(inner: S) -> Self {
        Self { inner, read: 0, written: 0 }
    }
}

impl<S: AsyncRead + Unpin> AsyncRead for Counted<S> {
    fn poll_read(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &mut ReadBuf<'_>,
    ) -> Poll<io::Result<()>> {
        let this = self.get_mut();
        let before = buf.filled().len();
        let poll = Pin::new(&mut this.inner).poll_read(cx, buf);
        this.read += (buf.filled().len() - before) as u64;
        poll
    }
}

impl<S: AsyncWrite + Unpin> AsyncWrite for Counted<S> {
    fn poll_write(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &[u8],
    ) -> Poll<io::Result<usize>> {
        let this = self.get_mut();
        let poll = Pin::new(&mut this.inner).poll_write(cx, buf);
        if let Poll::Ready(Ok(n)) = poll {
            this.written += n as u64;
        }
        poll
    }

    fn poll_flush(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<io::Result<()>> {
        Pin::new(&mut self.get_mut().inner).poll_flush(cx)
    }

    fn poll_shutdown(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<io::Result<()>> {
        Pin::new(&mut self.get_mut().inner).poll_shutdown(cx)
    }
}
