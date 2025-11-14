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
      gnumake
      cmake
      nodejs
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

  programs.zsh.shellAliases = {
    ai = "nvim -c 'lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)'";
  };
}
