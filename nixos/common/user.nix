{ config, ... }:

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
  };

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";

  security.sudo.wheelNeedsPassword = false;
}
