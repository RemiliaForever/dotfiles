{ lib, ... }:

{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    sessionVariables = { };
    shellAliases = {
      ls = "eza";
      ll = "eza -bghHliS";
      grep = "rg";
      ncdu = "ncdu --color=dark";
      ping = "prettyping";
      cat = "bat";
      diff = "delta";
      mutt = "neomutt";

      py = "ipython";
      latexmk = "latexmk -interaction=nonstopmode";
      vims = "vim --servername VIM";
      tig = "tig --date-order --all";
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
        "[\\] ](blue)"
        "$git_branch"
        "$git_commit$git_state"
        "$git_metrics"
        "$git_status"
        "$nix_shell"
        "$direnv"
        "$cmd_duration"
        "$jobs"
        "$status\n"
        "[└$character](bold green)"
      ];
      scan_timeout = 1000;
      command_timeout = 1000;
      username = {
        format = "[$user]($style)";
        style_user = "yellow";
        show_always = true;
      };
      hostname = {
        format = "[$ssh_symbol$hostname]($style)";
        style = "";
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
      };
      git_branch = {
        format = "\([$symbol$branch(:$remote_branch)]($style)\)";
      };
    };
  };
}
