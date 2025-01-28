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

  xdg.configFile = {
    "nvim/colors".source = ./colors;
    "nvim/lua".source = ./lua;
    "nvim/init.lua".source = ./init.lua;
  };
}
