//! Transport obfuscation / encryption layer.
//!
//! The whole connection is wrapped in AES-256-GCM. There is no plaintext magic
//! or fixed header: a connection opens with each side sending a 32-byte random
//! salt (indistinguishable from random noise), from which the session keys are
//! derived via HKDF-SHA256 over the pre-shared key. Everything after that is a
//! stream of AEAD frames, so there is no protocol fingerprint on the wire.
//!
//! Authentication is implicit: a peer that does not hold the correct PSK
//! derives the wrong key and every frame fails the GCM tag check, so the
//! connection is simply dropped.
//!
//! AES-GCM is used because RustCrypto's `aes`/`ghash` pick up AES-NI + CLMUL at
//! runtime on x86_64. On aarch64 the ARMv8 Cryptography Extensions backend is
//! compiled in when built with `RUSTFLAGS=--cfg aes_armv8` (set in the Nix
//! package), with a portable software fallback everywhere else.

use std::io;
use std::pin::Pin;
use std::task::{ready, Context, Poll};

use aes_gcm::aead::Aead;
use aes_gcm::{Aes256Gcm, KeyInit, Nonce};
use hkdf::Hkdf;
use sha2::Sha256;
use tokio::io::{AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt, ReadBuf};
use tokio::net::TcpStream;

/// An AES-256-GCM encrypted TCP connection.
pub type Enc = CryptoStream<TcpStream>;

const SALT_LEN: usize = 32;
const TAG_LEN: usize = 16;
const LEN_FIELD: usize = 2;
const LEN_FRAME: usize = LEN_FIELD + TAG_LEN; // encrypted 2-byte length + tag
const MAX_PAYLOAD: usize = 0x3FFF; // per Shadowsocks AEAD framing
const INFO: &[u8] = b"rtun aead v1";

fn derive_key(psk: &[u8], salt: &[u8]) -> [u8; 32] {
    let hk = Hkdf::<Sha256>::new(Some(salt), psk);
    let mut key = [0u8; 32];
    hk.expand(INFO, &mut key).expect("hkdf expand");
    key
}

/// One direction of the cipher, with its own monotonically increasing nonce.
struct AeadDir {
    cipher: Aes256Gcm,
    counter: u64,
}

impl AeadDir {
    fn new(key: [u8; 32]) -> Self {
        Self {
            cipher: Aes256Gcm::new_from_slice(&key).expect("32-byte key"),
            counter: 0,
        }
    }

    fn nonce(&self) -> [u8; 12] {
        let mut n = [0u8; 12];
        n[..8].copy_from_slice(&self.counter.to_le_bytes());
        n
    }

    fn seal(&mut self, plaintext: &[u8]) -> io::Result<Vec<u8>> {
        let nonce = self.nonce();
        let ct = self
            .cipher
            .encrypt(Nonce::from_slice(&nonce), plaintext)
            .map_err(|_| io::Error::other("encrypt failed"))?;
        self.counter = self.counter.wrapping_add(1);
        Ok(ct)
    }

    fn open(&mut self, ciphertext: &[u8]) -> io::Result<Vec<u8>> {
        let nonce = self.nonce();
        let pt = self
            .cipher
            .decrypt(Nonce::from_slice(&nonce), ciphertext)
            .map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "auth/decrypt failed"))?;
        self.counter = self.counter.wrapping_add(1);
        Ok(pt)
    }
}

enum ReadState {
    Len,
    Data,
}

/// An `AsyncRead + AsyncWrite` wrapper that transparently AEAD-encrypts.
pub struct CryptoStream<S> {
    inner: S,
    enc: AeadDir,
    dec: AeadDir,

    // Read side.
    rstate: ReadState,
    cbuf: Vec<u8>, // accumulates the ciphertext for the current frame
    cfilled: usize,
    plain: Vec<u8>, // decrypted bytes not yet handed to the caller
    ppos: usize,

    // Write side.
    wbuf: Vec<u8>, // ciphertext pending flush
    wpos: usize,
}

impl<S> CryptoStream<S> {
    fn new(inner: S, enc: AeadDir, dec: AeadDir) -> Self {
        Self {
            inner,
            enc,
            dec,
            rstate: ReadState::Len,
            cbuf: vec![0u8; LEN_FRAME],
            cfilled: 0,
            plain: Vec::new(),
            ppos: 0,
            wbuf: Vec::new(),
            wpos: 0,
        }
    }

    fn poll_flush_buf(&mut self, cx: &mut Context<'_>) -> Poll<io::Result<()>>
    where
        S: AsyncWrite + Unpin,
    {
        while self.wpos < self.wbuf.len() {
            match Pin::new(&mut self.inner).poll_write(cx, &self.wbuf[self.wpos..]) {
                Poll::Ready(Ok(0)) => {
                    return Poll::Ready(Err(io::Error::new(
                        io::ErrorKind::WriteZero,
                        "write zero",
                    )))
                }
                Poll::Ready(Ok(n)) => self.wpos += n,
                Poll::Ready(Err(e)) => return Poll::Ready(Err(e)),
                Poll::Pending => return Poll::Pending,
            }
        }
        self.wbuf.clear();
        self.wpos = 0;
        Poll::Ready(Ok(()))
    }

    /// Appends an encrypted `[len][payload]` frame to the write buffer.
    fn encode_frame(&mut self, plaintext: &[u8]) -> io::Result<()> {
        let len = self.enc.seal(&(plaintext.len() as u16).to_be_bytes())?;
        self.wbuf.extend_from_slice(&len);
        let body = self.enc.seal(plaintext)?;
        self.wbuf.extend_from_slice(&body);
        Ok(())
    }
}

/// Performs the salt exchange and returns an encrypted stream.
pub async fn handshake<S>(mut stream: S, psk: &[u8]) -> io::Result<CryptoStream<S>>
where
    S: AsyncRead + AsyncWrite + Unpin,
{
    let mut local_salt = [0u8; SALT_LEN];
    getrandom::getrandom(&mut local_salt).map_err(|e| io::Error::other(e.to_string()))?;
    stream.write_all(&local_salt).await?;
    stream.flush().await?;

    let mut remote_salt = [0u8; SALT_LEN];
    stream.read_exact(&mut remote_salt).await?;

    // Encrypt with a key bound to our salt; decrypt with the peer's.
    let enc = AeadDir::new(derive_key(psk, &local_salt));
    let dec = AeadDir::new(derive_key(psk, &remote_salt));
    Ok(CryptoStream::new(stream, enc, dec))
}

impl<S: AsyncRead + Unpin> AsyncRead for CryptoStream<S> {
    fn poll_read(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &mut ReadBuf<'_>,
    ) -> Poll<io::Result<()>> {
        let this = self.get_mut();
        loop {
            // No room to deliver into; not EOF, just nothing to do yet.
            if buf.remaining() == 0 {
                return Poll::Ready(Ok(()));
            }
            if this.ppos < this.plain.len() {
                let n = std::cmp::min(buf.remaining(), this.plain.len() - this.ppos);
                buf.put_slice(&this.plain[this.ppos..this.ppos + n]);
                this.ppos += n;
                return Poll::Ready(Ok(()));
            }

            // Read the current frame's ciphertext in full.
            while this.cfilled < this.cbuf.len() {
                let mut tmp = ReadBuf::new(&mut this.cbuf[this.cfilled..]);
                ready!(Pin::new(&mut this.inner).poll_read(cx, &mut tmp))?;
                let n = tmp.filled().len();
                if n == 0 {
                    if matches!(this.rstate, ReadState::Len) && this.cfilled == 0 {
                        return Poll::Ready(Ok(())); // clean EOF at a frame boundary
                    }
                    return Poll::Ready(Err(io::Error::new(
                        io::ErrorKind::UnexpectedEof,
                        "truncated frame",
                    )));
                }
                this.cfilled += n;
            }

            match this.rstate {
                ReadState::Len => {
                    let pt = this.dec.open(&this.cbuf)?;
                    let len = u16::from_be_bytes([pt[0], pt[1]]) as usize;
                    if len == 0 || len > MAX_PAYLOAD {
                        return Poll::Ready(Err(io::Error::new(
                            io::ErrorKind::InvalidData,
                            "bad frame length",
                        )));
                    }
                    this.rstate = ReadState::Data;
                    this.cbuf.resize(len + TAG_LEN, 0);
                    this.cfilled = 0;
                }
                ReadState::Data => {
                    this.plain = this.dec.open(&this.cbuf)?;
                    this.ppos = 0;
                    this.rstate = ReadState::Len;
                    this.cbuf.resize(LEN_FRAME, 0);
                    this.cfilled = 0;
                }
            }
        }
    }
}

impl<S: AsyncWrite + Unpin> AsyncWrite for CryptoStream<S> {
    fn poll_write(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &[u8],
    ) -> Poll<io::Result<usize>> {
        let this = self.get_mut();
        // Never buffer a second frame before the previous one is on the wire.
        ready!(this.poll_flush_buf(cx))?;
        if buf.is_empty() {
            return Poll::Ready(Ok(0));
        }
        let take = std::cmp::min(buf.len(), MAX_PAYLOAD);
        if let Err(e) = this.encode_frame(&buf[..take]) {
            return Poll::Ready(Err(e));
        }
        // Best effort: leftover stays in wbuf and is flushed on the next call.
        let _ = this.poll_flush_buf(cx)?;
        Poll::Ready(Ok(take))
    }

    fn poll_flush(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<io::Result<()>> {
        let this = self.get_mut();
        ready!(this.poll_flush_buf(cx))?;
        Pin::new(&mut this.inner).poll_flush(cx)
    }

    fn poll_shutdown(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<io::Result<()>> {
        let this = self.get_mut();
        ready!(this.poll_flush_buf(cx))?;
        Pin::new(&mut this.inner).poll_shutdown(cx)
    }
}
