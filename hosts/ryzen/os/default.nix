{ ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/opt/aagl.nix
    ../../../nixos/opt/spotify.nix
    ../../../nixos/opt/virtualisation.nix
    ../../../nixos/opt/wireshark.nix
  ];

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };
}
