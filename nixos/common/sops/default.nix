{ ... }:

{
  sops = {
    gnupg.home = "/var/lib/sops";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "hashedPassword".neededForUsers = true;
      "singbox/server" = { };
      "singbox/uuid" = { };
    };
  };
}
