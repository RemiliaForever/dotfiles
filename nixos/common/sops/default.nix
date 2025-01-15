{ config, ... }:

{
  sops = {
    gnupg.home = "/var/lib/sops";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "hashedPassword".neededForUsers = true;
      "ddns/id" = { };
      "ddns/secret" = { };
      "mail/koumakan/address".owner = config.users.users.remilia.name;
      "mail/koumakan/password".owner = config.users.users.remilia.name;
      "mail/deepglint/address".owner = config.users.users.remilia.name;
      "mail/deepglint/password".owner = config.users.users.remilia.name;
      "singbox/server" = { };
      "singbox/server_name" = { };
      "singbox/uuid" = { };
    };
  };
}
