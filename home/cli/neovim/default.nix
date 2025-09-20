{ pkgs, ... }:

let
  mcp-hub = pkgs.buildNpmPackage rec {
    pname = "mcp-hub";
    version = "4.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "ravitemer";
      repo = "mcp-hub";
      tag = "v${version}";
      hash = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
    };

    npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g=";
  };
in
{
  # generate json from nix
  home.file.".config/mcphub/servers.json".text = builtins.toJSON {
    mcpServers = {
      google_search = {
        command = "npx";
        args = [
          "-y"
          "@adenot/mcp-google-search"
        ];
        env = {
          "GOOGLE_API_KEY" = ''''${GOOGLE_API_KEY}'';
          "GOOGLE_SEARCH_ENGINE_ID" = ''''${GOOGLE_SEARCH_ENGINE_ID}'';
        };
      };
    };
    nativeMCPServers = {
      mcphub.disabled = true;
      neovim.disabled = false;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # tool
      xxd
      # plugin
      gcc
      gnumake
      cmake
      nodejs
      mcp-hub
      # conform
      clang-tools
      go
      isort
      nixfmt-rfc-style
      nodePackages.prettier
      rustfmt
      stylua
      taplo
      yapf
      # lsp
      bash-language-server
      vscode-langservers-extracted
      dockerfile-language-server
      docker-compose-language-service
      gopls
      neocmakelsp
      nixd
      openscad-lsp
      basedpyright
      typescript-language-server
      lua-language-server
      rust-analyzer
      texlab
      vue-language-server
    ];
  };
  home.sessionVariables = {
    GOPATH = "$HOME/.go";
  };

  xdg.configFile = {
    "nvim/colors".source = ./colors;
    "nvim/lua".source = ./lua;
    "nvim/init.lua".source = ./init.lua;
  };
}
