{ pkgs, ... }:

{
  home.packages = with pkgs; [ tig ];
  programs = {
    git = {
      enable = true;
      userName = "RemiliaForever";
      userEmail = "remilia@koumakan.cc";
      signing.key = "remilia@koumakan.cc";

      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lgi = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lgs = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --show-signature";
        cs = "commit -S -m";
        cas = "commit -S -a -m";
        ca = "commit -a -m";
        cm = "commit -m";
        cem = "commit --allow-empty -m";
        cd = "commit --amend --no-edit";
        dt = "difftool";
        mt = "mergetool";
        c = "commit -m";
        d = "diff";
        f = "fetch -p -t";
        pl = "pull --ff -p";
        ps = "push";
        s = "status";
      };

      delta = {
        enable = true;
        options = {
          navigate = true;
          features = "side-by-side decorations";
          decorations = {
            commit-decoration-style = "bold box ul";
            dark = "true";
            file-decoration-style = "none";
            file-style = "omit";
            hunk-header-decoration-style = "blue box ul";
            hunk-header-file-style = "#999999";
            hunk-header-line-number-style = "bold blue";
            hunk-header-style = "file line-number syntax";
            line-numbers = "true";
            line-numbers-left-style = "blue";
            line-numbers-minus-style = "red";
            line-numbers-plus-style = "green";
            line-numbers-right-style = "blue";
            line-numbers-zero-style = "#999999";
            minus-emph-style = "normal #80002a";
            minus-style = "normal #330011";
            plus-emph-style = "syntax #003300";
            plus-style = "syntax #001a00";
          };
        };
      };

      extraConfig = {
        core.autocrlf = "input";
        fetch.prune = true;
        push.default = "simple";
        diff = {
          tool = "nvimdiff";
          colorMoved = "default";
        };
        difftool.nvimdiff = {
          prompt = false;
          cmd = "nvim -d $LOCAL $MERGED $REMOTE";
        };
        color.ui = true;
      };

      lfs.enable = true;

      ignores = [
        ".env"
        ".envrc"
        ".secrets"
        ".direnv"
        ".shell"
        ".shell.nix"
        "TODO.md"
        "avante.md"
      ];
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showBranchCommitHash = true;
          commandLogSize = 6;
          switchTabsWithPanelJumpKeys = true;
          statusPanelView = "allBranchesLog";
        };
        git = {
          paging = {
            colorArg = "always";
            parseEmoji = true;
          };
          branchLogCmd = "git lg {{branchName}}";
          allBranchesLogCmds = [
            "git lg --all"
            "git lgi --all"
            "git lgs --all"
          ];
          log = {
            showWholeGraph = true;
          };
        };
        customCommands = [
          {
            context = "subCommits";
            key = "t";
            command = "tig show {{.SelectedSubCommit.Sha}}";
            description = "tig commit (`t` again to browse files at revision)";
            output = "terminal";
          }
          {
            context = "localBranches";
            key = "t";
            command = "tig show {{.SelectedLocalBranch.Name}}";
            description = "tig branch (`t` again to browse files at revision)";
            output = "terminal";
          }
          {
            context = "remoteBranches";
            key = "t";
            command = "tig show {{.SelectedRemoteBranch.RemoteName}}/{{.SelectedRemoteBranch.Name}}";
            description = "tig branch (`t` again to browse files at revision)";
            output = "terminal";
          }
          {
            context = "commitFiles";
            key = "t";
            command = "tig {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            description = "tig file (history of commits affecting file)";
            output = "terminal";
          }
          {
            key = "t";
            command = "tig -- {{.SelectedFile.Name}}";
            context = "files";
            description = "tig file (history of commits affecting file)";
            output = "terminal";
          }
          {
            context = "files";
            key = "b";
            command = "tig blame -- {{.SelectedFile.Name}}";
            description = "blame file at tree";
            output = "terminal";
          }
          {
            context = "commitFiles";
            key = "b";
            command = "tig blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            description = "blame file at revision";
            output = "terminal";
          }
          {
            context = "commitFiles";
            key = "B";
            command = "tig blame -- {{.SelectedCommitFile.Name}}";
            description = "blame file at tree";
            output = "terminal";
          }
        ];
      };
    };

    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-copilot
        gh-dash

        gh-s
        gh-i
        gh-notify
      ];
    };
    zsh.completionInit = ''eval "$(${pkgs.gh-copilot}/bin/gh-copilot alias zsh)"'';
  };
}
