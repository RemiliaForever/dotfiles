{ lib, ... }:
{
  nixpkgs.overlays = [
    (final: previous: {
      # https://github.com/NixOS/nixpkgs/issues/392673
      # aarch64-unknown-linux-musl-ld: (.text+0x484): warning: too many GOT entries for -fpic, please recompile with -fPIC
      nettle = previous.nettle.overrideAttrs (
        lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
          CCPIC = "-fPIC";
        }
      );
    })
    # https://github.com/NixOS/nixpkgs/issues/366902
    (final: prev: {
      qemu-user = prev.qemu-user.overrideAttrs (
        old:
        lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
          configureFlags = old.configureFlags ++ [ "--disable-pie" ];
        }
      );
    })
  ];
}
