{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      gcc
      cmake

      universal-ctags
      xxd

      clang-tools
      go
      isort
      nixfmt-rfc-style
      nodePackages.prettier
      rustfmt
      stylua
      taplo
      yapf
    ];
  };

  home.file = {
    ".config/nvim/colors".source = ./colors;
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/init.lua".source = ./init.lua;
  };

  home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/mkdir -p $HOME/.cache/nvim/tags
  '';
}
