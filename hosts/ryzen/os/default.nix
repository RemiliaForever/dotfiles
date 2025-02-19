{ ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam.nix
    ../../../nixos/virtualisation.nix
    ../../../nixos/wireshark.nix
  ];
}
