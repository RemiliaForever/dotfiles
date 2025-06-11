{ config, ... }:

let
  user = {
    owner = config.users.users.remilia.name;
  };
in
{
  sops = {
    gnupg.home = "/var/lib/sops";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "hashedPassword".neededForUsers = true;
      "mail/koumakan/address" = user;
      "mail/koumakan/password" = user;
      "mail/nexa4ai/address" = user;
      "mail/nexa4ai/password" = user;
      "api/deepseek" = user;
      "api/anthropic" = user;
      "singbox/server" = { };
      "singbox/server_name" = { };
      "singbox/uuid" = { };
    };
  };
}
