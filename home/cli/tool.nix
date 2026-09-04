{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    comma
    prettyping
    trash-cli
    xh
    rsync
    (pass-nodmenu.withExtensions (ext: [ ext.pass-otp ]))

    claude-code
    pi-coding-agent
  ];

  home.sessionVariables = {
    COMMA_PICKER = "fzf";
  };

  # rsync
  programs.zsh.shellAliases.rsync =
    let
      excludeFile = pkgs.writeText "rsync-exclude" ''
        .ccache/
        .direnv/
        .shell/
        bazel-*/
        build*/
        dist*/
        node_modules/
        pkg*/
        target*/
        .envrc
        .git
        .DS_Store
      '';
    in
    "rsync -avP --delete --exclude-from=${excludeFile}";

  # copilot
  home.file =
    let
      prompt = pkgs.writeText "prompt" ''
        # Response

        Write in English by default. Always reply to the user in Chinese. Keep proper nouns in their original form.

        Format replies to the user as markdown.

        # Workflow

        OS is NixOS. If a command is not available, invoke it via `nix shell nixpkgs#<package> -c <command>`.

        Before reporting a task complete, clean up incidental artifacts you generated (e.g. `nix build`'s `result` symlink, scratch files under `/tmp`). Leave alone pre-existing files, normal build outputs (`target/`, `dist/`), and outputs the user asked to keep. Ask if unsure.

        When creating a new git worktree, place it under `.pi/worktrees/` at the project root (e.g. `.pi/worktrees/<name>`).

        # Coding

        Keep code simple. Avoid unnecessary abstractions, speculative parameters, or indirection — add them only when there's a concrete need, not a hypothetical one.

        Do not add comment if possible, keep comments concise.

        # Temp Files

        Use `.pi/temp/:filename:` in project root for temporary files. Do not put files in system/user temp dir.

        Clean up temp files after job completion. If a temp file is needed for debugging, ask the user to save it explicitly.

        # Background Tasks

        Use bg_run to run background tasks. Avoid using `nohup` or `setsid` make background task not tracable.
      '';
    in
    {
      ".claude/CLAUDE.md".source = prompt;
      ".pi/agent/AGENTS.md".source = prompt;
    };
  programs.zsh.shellAliases = {
    aq = "pi --models 'qgenie/*'";
    ab = "pi --models 'breeze/*'";
    ag = "pi --models 'github-copilot/gpt-5.6-luna,github-copilot/gpt-5.6-sol,github-copilot/claude-opus-5,github-copilot/claude-sonnet-5'";
  };

  programs.fzf = {
    enable = true;
  };

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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        warn_timeout = 0;
      };
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
        "$python"
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
        ssh_symbol = "☆ ";
      };
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style)";
        style = "yellow";
        read_only = "";
        truncation_length = 2;
        fish_style_pwd_dir_length = 1;
      };
      jobs = {
        symbol = "♦ ";
      };
      cmd_duration = {
        format = "[ $duration]($style) ";
      };
      python = {
        format = "[$symbol]($style) ";
        symbol = "🐍";
        detect_extensions = [ ];
        detect_files = [ ];
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
    defaultCacheTtl = 604800; # default unlock time: 1 week
    maxCacheTtl = 2147483647; # never timeout
  };

}
