{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    prettyping
    xh
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

    ranger = {
      enable = true;
      extraConfig = "";
      extraPackages = [ ];
      settings = {
        confirm_on_delete = "never";
        draw_borders = true;
        preview_images = true;
        #preview_images_method = "wezterm-image-display-method";
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
    bash.bashrcExtra = ''
      # ranger
      function ranger-cd {
          local temp_file
          temp_file=$(mktemp)
          ranger --choosedir="$temp_file" "$@"
          if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" != "$(pwd)" ]; then
              cd -- "$(cat "$temp_file")"
          fi
          rm -f -- "$temp_file"
      }
      bind '"\C-o":"\C-u ranger-cd\C-m"'
    '';
  };
}
