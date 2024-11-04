{ pkgs, ... }:

{
  home.packages = with pkgs; [ prettyping ];
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

    ranger = {
      enable = true;
      extraConfig = "";
      extraPackages = [ ];
      settings = {
        confirm_on_delete = "never";
        draw_borders = true;
        preview_images = true;
        preview_images_method = "ueberzug";
        unicode_ellipsis = true;
        use_preview_script = true;
      };
      plugins = [
        {
          name = "ranger_devicons";
          src = builtins.fetchGit {
            url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
            rev = "a8d626485ca83719e1d8d5e32289cd96a097c861";
          };
        }
      ];
    };
  };
}
