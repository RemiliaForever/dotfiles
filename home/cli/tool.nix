{ pkgs, lib, ... }:

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

  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 1000;
      command_timeout = 1000;
      format = "$hostname $directory $character";
      right_format = lib.concatStrings [
        "$jobs"
        "$cmd_duration"
        "$nix_shell"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$time"
      ];

      hostname = {
        format = "[$ssh_symbol]($style)";
        # style = "";
        ssh_only = true;
        ssh_symbol = "🌐";
      };
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style)";
        style = "yellow";
        read_only = "";
        truncation_length = 2;
        fish_style_pwd_dir_length = 1;
      };
      jobs = {
        symbol = "✦ ";
      };
      cmd_duration = {
        format = "[ $duration]($style) ";
      };
      nix_shell = {
        format = "[$state]($style) ";
        heuristic = true;
        impure_msg = "󰼩 ";
        pure_msg = "󱩰 ";
        unknown_msg = "󰜗 ";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "purple";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

}
