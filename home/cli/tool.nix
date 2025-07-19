{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prettyping
    xh
    trash-cli
  ];

  programs = {
    bat = {
      enable = true;
      extraPackages = [ ];
      config = {
        theme = "OneHalfDark";
        pager = "less -RF";
      };
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    fd = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    fzf = {
      enable = true;
      changeDirWidgetCommand = null;
      changeDirWidgetOptions = [ ];
      defaultCommand = null;
      defaultOptions = [ ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };
}
