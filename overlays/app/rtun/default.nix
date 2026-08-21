{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "rtun";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  cargoLock.lockFile = ./Cargo.lock;

  # Enable the ARMv8 Cryptography Extensions backend for AES-GCM on aarch64.
  # No-op on x86_64, where RustCrypto detects AES-NI + CLMUL at runtime.
  RUSTFLAGS = "--cfg aes_armv8";

  meta = {
    description = "Reverse port-forwarding and reverse SOCKS5 tunnel without the SSH protocol";
    mainProgram = "rtun";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
