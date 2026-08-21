//! rtun — reverse tunnel without the SSH protocol.
//!
//! Mirrors `ssh -N -R ...` reverse forwarding and `-R <port>` dynamic (SOCKS)
//! forwarding, but with its own protocol wrapped in an AES-256-GCM obfuscation
//! layer (no plaintext header on the wire; the pre-shared key doubles as
//! authentication). See the module docs for details:
//!
//!   * [`crypto`]   — the transport encryption/obfuscation layer
//!   * [`protocol`] — framing and control messages
//!   * [`server`]   — binds ports and relays their traffic
//!   * [`client`]   — dials targets on the server's behalf

mod client;
mod crypto;
mod protocol;
mod server;
mod socks;
mod tunnel;

use anyhow::Result;
use clap::{Parser, Subcommand};

use client::Client;
use server::Server;

/// Built-in shared key so a LAN deployment works without configuration.
/// Override with `--secret` / `RTUN_SECRET` for anything reachable off-LAN.
const DEFAULT_SECRET: &str = "rtun-lan-default";

#[derive(Parser)]
#[command(name = "rtun", version, about = "Reverse port-forward / SOCKS tunnel without SSH")]
struct Cli {
    #[command(subcommand)]
    cmd: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Run the server (the side that exposes the ports).
    Server(ServerArgs),
    /// Run the client (the side whose network/services are exposed).
    Client(ClientArgs),
}

#[derive(Parser)]
pub struct ServerArgs {
    /// Address to accept client control/data connections on.
    #[arg(long, default_value = "0.0.0.0:13300")]
    pub listen: String,
    /// Pre-shared key; must match the client. Also the AEAD key material.
    #[arg(long, env = "RTUN_SECRET", default_value = DEFAULT_SECRET)]
    pub secret: String,
}

#[derive(Parser)]
pub struct ClientArgs {
    /// Server address (`host:port`).
    pub server: String,
    /// Reverse tunnel spec. Repeatable. Forms:
    ///   BINDPORT:HOST:HOSTPORT, [BINDADDR:]BINDPORT (SOCKS), BINDADDR:BINDPORT:HOST:HOSTPORT
    #[arg(short = 'R', long = "remote", value_name = "SPEC")]
    pub remotes: Vec<String>,
    /// Pre-shared key; must match the server. Also the AEAD key material.
    #[arg(long, env = "RTUN_SECRET", default_value = DEFAULT_SECRET)]
    pub secret: String,
    /// Keepalive ping interval in seconds (0 disables).
    #[arg(long, default_value_t = 30)]
    pub keepalive_interval: u64,
    /// Consecutive missed keepalives before the connection is dropped.
    #[arg(long, default_value_t = 3)]
    pub keepalive_count: u64,
    /// Exit instead of reconnecting when the connection drops.
    #[arg(long)]
    pub no_reconnect: bool,
}

#[tokio::main]
async fn main() -> Result<()> {
    match Cli::parse().cmd {
        Command::Server(args) => Server::new(args.secret).run(&args.listen).await,
        Command::Client(args) => Client::from_args(args)?.run().await,
    }
}
