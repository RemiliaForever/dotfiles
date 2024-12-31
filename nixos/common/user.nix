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
      #"keys"
      "video"
      "audio"
      "dialout"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";
}
