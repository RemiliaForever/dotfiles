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
      format = lib.concatStrings [
        "[┌\\[](blue)"
        "$username"
        "$hostname"
        "[\\]-\\[](blue)"
        "$time"
        "[\\]-\\[](blue)"
        "$directory"
        "[\\]](blue) "
        "$git_branch"
        "$git_commit$git_state"
        "$git_metrics"
        "$git_status"
        "$nix_shell"
        "$direnv"
        "$cmd_duration"
        "$jobs"
        "$status\n"
        "[└](blue)"
        "$character"
      ];
      scan_timeout = 1000;
      command_timeout = 1000;
      username = {
        format = "[$user]($style)";
        style_user = "green";
        show_always = true;
      };
      hostname = {
        format = "[$ssh_symbol](blue)[$hostname]($style)";
        # style = "";
        ssh_only = true;
        ssh_symbol = " 🌐 ";
      };
      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "purple";
      };
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style)";
        style = "yellow";
        read_only = "";
        truncation_length = 2;
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      nix_shell = {
        format = "[$state]($style) ";
        heuristic = true;
        impure_msg = "󰼩 ";
        pure_msg = "󱩰 ";
        unknown_msg = "󰜗 ";
      };
      cmd_duration = {
        format = "[ $duration]($style) ";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

}
