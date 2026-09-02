{ ... }:

{
  sops = {
    gnupg.home = ".gnupg";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "mail/koumakan/address" = { };
      "mail/koumakan/password" = { };
      "api/deepseek" = { };
      "api/anthropic" = { };
      "api/google_api_key" = { };
      "api/google_search_engine_id" = { };
    };
  };
}
