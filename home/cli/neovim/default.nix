{ pkgs, ... }:

{
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
      cmake
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
      dockerfile-language-server-nodejs
      docker-compose-language-service
      gopls
      neocmakelsp
      nixd
      openscad-lsp
      pyright
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
