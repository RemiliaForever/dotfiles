{ ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/aagl.nix
    ../../../nixos/virtualisation.nix
    ../../../nixos/wireshark.nix

  ];

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };
}
