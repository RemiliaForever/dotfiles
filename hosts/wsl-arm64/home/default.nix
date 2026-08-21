{ lib, pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
  ];

  home.packages = with pkgs; [
    rtun
  ];

  # override sops
  systemd.user.services.sops-nix.Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";

  # cli
  programs = {
    starship.settings.format = lib.mkForce "\\(wsl\\) $directory $character";
    gh.gitCredentialHelper.hosts = [
      "github.com"
      "gist.github.com"
      "github.qualcomm.com"
    ];
  };

  home.sessionVariables = {
  };
}
