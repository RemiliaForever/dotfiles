{ lib, ... }:

{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    sessionVariables = { };
    shellAliases = {
      cat = "bat";
      diff = "delta";
      ll = "eza -bghHliS";
      mutt = "neomutt";
      ping = "prettyping";
      py = "ipython";
      lg = "lazygit";

      latexmk = "latexmk -interaction=nonstopmode";
      ncdu = "ncdu --color=dark";
      vims = "vim --servername VIM";
    };
    bashrcExtra = ''
      # extra
    '';
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
        format = "[$ssh_symbol$hostname]($style)";
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
}
