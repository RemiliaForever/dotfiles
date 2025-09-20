{ config, ... }:

{
  sops = {
    gnupg.home = ".gnupg";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "mail/koumakan/address" = { };
      "mail/koumakan/password" = { };
      "mail/nexa4ai/address" = { };
      "mail/nexa4ai/password" = { };
      "api/deepseek" = { };
      "api/anthropic" = { };
      "api/gemini" = { };
      "api/google_api_key" = { };
      "api/google_search_engine_id" = { };
    };
  };

  programs.zsh.initContent = ''
    # sops
    export DEEPSEEK_API_KEY=$(cat ${config.sops.secrets."api/deepseek".path})
    export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets."api/anthropic".path})
    export GEMINI_API_KEY=$(cat ${config.sops.secrets."api/gemini".path})
    export GOOGLE_API_KEY=$(cat ${config.sops.secrets."api/google_api_key".path})
    export GOOGLE_SEARCH_ENGINE_ID=$(cat ${config.sops.secrets."api/google_search_engine_id".path})
  '';
}
