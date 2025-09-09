{ lib, ... }:

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

  #services.flatpak.enable = true;

  # build machine keep more generations
  programs.nh.clean = {
    dates = lib.mkForce "weekly";
    extraArgs = lib.mkForce "--keep 5 --keep-since 4w";
  };

  # deluge
  services.deluge = {
    enable = true;
    user = "remilia";
    group = "users";
    dataDir = "/home/remilia";
  };
}
