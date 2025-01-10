{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gcc
      cmake
      python3
      universal-ctags

      pkgs.nixfmt-rfc-style
    ];
  };

  home.file = {
    ".config/nvim/colors".source = ./colors;
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/init.lua".source = ./init.lua;
  };
}
