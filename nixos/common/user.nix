{ config, pkgs, ... }:

{
  users.mutableUsers = false;
  users.users.remilia = {
    uid = 1000;
    isNormalUser = true;
    description = "RemiliaForever";
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "dialout"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";

  security.sudo.wheelNeedsPassword = false;
}
