{ lib, pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
  ];

  home.packages = [
  ];

  # override sops
  systemd.user.services.sops-nix.Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";

  # cli

  home.sessionVariables = {
  };
}
