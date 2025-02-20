{ config, ... }:

{
  sops = {
    gnupg.home = "/var/lib/sops";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "hashedPassword".neededForUsers = true;
      "mail/koumakan/address".owner = config.users.users.remilia.name;
      "mail/koumakan/password".owner = config.users.users.remilia.name;
      "singbox/server" = { };
      "singbox/server_name" = { };
      "singbox/uuid" = { };
    };
  };
}
