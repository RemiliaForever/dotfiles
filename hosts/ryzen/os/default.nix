{ lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/opt/aagl.nix
    ../../../nixos/opt/steamos.nix
    ../../../nixos/opt/virtualisation.nix
    ../../../nixos/opt/wireshark.nix
  ];

  services.zerotierone = {
    enableGame = true;
  };

  # build machine keep more generations
  programs.nh.clean = {
    dates = lib.mkForce "weekly";
    extraArgs = lib.mkForce "--keep 5 --keep-since 4w";
  };

  services.sing-box.settings = {
    inbounds = [
      {
        tag = "http-in";
        type = "http";
        listen = "0.0.0.0";
        listen_port = 1080;
      }
    ];
  };

  # deluge
  services.deluge = {
    enable = true;
    user = "remilia";
    group = "users";
    dataDir = "/home/remilia";
  };
  systemd.services.deluged.serviceConfig.MemoryHigh = "1G";

  # rtun server: accepts client tunnels and binds the ports they request
  systemd.services.rtun = {
    description = "rtun reverse tunnel server";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rtun}/bin/rtun server --listen 0.0.0.0:13300";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };
}
