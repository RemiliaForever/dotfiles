{ pkgs, config, ... }:

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

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";

  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.pam.services.Hyprland.kwallet.enable = true;
  security.pam.services.Hyprland.kwallet.package = pkgs.kdePackages.kwallet-pam;
}
