//! rtun — reverse tunnel without the SSH protocol.
//!
//! Mirrors `ssh -N -R ...` reverse forwarding and `-R <port>` dynamic (SOCKS)
//! forwarding, but with its own protocol wrapped in an AES-256-GCM obfuscation
//! layer (no plaintext header on the wire; the pre-shared key doubles as
//! authentication).

mod client;
mod crypto;
mod net;
mod protocol;
mod server;
mod socks;
mod stats;
mod tunnel;

use std::io::IsTerminal;
use std::process::ExitCode;

use clap::builder::styling::{AnsiColor, Effects, Styles};
use clap::{Parser, Subcommand};
use time::macros::format_description;
use time::UtcOffset;
use tracing::{error, warn, Level};
use tracing_subscriber::fmt::time::OffsetTime;

use client::Client;
use server::Server;
use tunnel::Tunnel;

/// Built-in key so a LAN deployment works unconfigured; override off-LAN.
const DEFAULT_SECRET: &str = "rtun-lan-default";

/// Coloured `--help` / error output; clap only bolds by default.
const STYLES: Styles = Styles::styled()
    .header(AnsiColor::Green.on_default().effects(Effects::BOLD))
    .usage(AnsiColor::Green.on_default().effects(Effects::BOLD))
    .literal(AnsiColor::Cyan.on_default().effects(Effects::BOLD))
    .placeholder(AnsiColor::Cyan.on_default())
    .error(AnsiColor::Red.on_default().effects(Effects::BOLD))
    .invalid(AnsiColor::Yellow.on_default());

/// Logs to stderr, coloured only on a terminal so journald stays plain.
fn init_logging(level: Level, offset: UtcOffset) {
    let fmt = format_description!("[year]-[month]-[day]T[hour]:[minute]:[second].[subsecond digits:3][offset_hour sign:mandatory]:[offset_minute]");
    tracing_subscriber::fmt()
        .with_max_level(level)
        .with_writer(std::io::stderr)
        .with_ansi(std::io::stderr().is_terminal())
        .with_timer(OffsetTime::new(offset, fmt))
        .init();
}

#[derive(Parser)]
#[command(
    name = "rtun",
    version,
    about = "Reverse port-forward / SOCKS tunnel without SSH",
    styles = STYLES
)]
struct Cli {
    #[command(subcommand)]
    cmd: Command,
    /// Log verbosity: error, warn, info, debug or trace (either side of the
    /// subcommand).
    #[arg(long, global = true, env = "RTUN_LOG", default_value = "info")]
    log_level: Level,
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
    #[arg(short = 'R', long = "remote", value_name = "SPEC", required = true)]
    pub remotes: Vec<Tunnel>,
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

fn main() -> ExitCode {
    let cli = Cli::parse();
    // `time` refuses to read the local offset once the process is multi-threaded,
    // and building the runtime below starts the worker threads.
    let (offset, offset_err) = match UtcOffset::current_local_offset() {
        Ok(o) => (o, None),
        Err(e) => (UtcOffset::UTC, Some(e)),
    };
    init_logging(cli.log_level, offset);
    if let Some(e) = offset_err {
        warn!("no local UTC offset ({e}); timestamps are UTC");
    }

    let rt = match tokio::runtime::Runtime::new() {
        Ok(rt) => rt,
        Err(e) => {
            error!("cannot start the async runtime: {e}");
            return ExitCode::FAILURE;
        }
    };
    if rt.block_on(run(cli.cmd)) {
        ExitCode::FAILURE
    } else {
        ExitCode::SUCCESS
    }
}

/// Runs the requested role, returning true if it failed.
async fn run(cmd: Command) -> bool {
    match cmd {
        Command::Server(args) => Server::new(args.secret)
            .run(&args.listen)
            .await
            .inspect_err(|e| error!(target: "server", "{e:#}"))
            .is_err(),
        Command::Client(args) => Client::from_args(args)
            .run()
            .await
            .inspect_err(|e| error!(target: "client", "{e:#}"))
            .is_err(),
    }
}
