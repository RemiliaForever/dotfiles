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
      cmake
      gcc
      gnumake
      nodejs
      cargo
      rustc
      tree-sitter
      # conform
      clang-tools
      go
      nixfmt
      prettier
      ruff
      rustfmt
      stylua
      taplo
      # lsp
      basedpyright
      bash-language-server
      docker-compose-language-service
      dockerfile-language-server
      gopls
      kotlin-lsp
      lua-language-server
      neocmakelsp
      nixd
      openscad-lsp
      rust-analyzer
      texlab
      typescript-language-server
      vscode-langservers-extracted
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
