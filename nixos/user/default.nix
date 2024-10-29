{ config, ... }:

{
  sops = {
    gnupg.home = "/var/lib/sops";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      hashedPassword.neededForUsers = true;
      "mail/koumakan/address".owner = config.users.users.remilia.name;
      "mail/koumakan/password".owner = config.users.users.remilia.name;
      "mail/deepglint/address".owner = config.users.users.remilia.name;
      "mail/deepglint/password".owner = config.users.users.remilia.name;
    };
  };

  users.mutableUsers = false;
  users.users.remilia = {
    isNormalUser = true;
    description = "RemiliaForever";
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = [
      "wheel"
      "keys"
      "video"
      "audio"
      "networkmanager"

      "podman"
      "libvirtd"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";
}
