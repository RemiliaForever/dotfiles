{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    history = {
      append = true;
      ignoreAllDups = true;
      saveNoDups = true;
      share = false;
      size = 65536;
    };

    autocd = true;
    defaultKeymap = "emacs";

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

      cb = "nice -n 19 cmake --build build -j";
      ct = "ctest --test-dir build";
    };

    # extra completion without install it
    completionInit = ''
      fpath=(
        ${pkgs.bazel}/share/zsh/site-functions
        $fpath
      )
      autoload -U compinit && compinit
    '';

    initContent = ''
      # keybind
      WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
      bindkey '\e[1;5D' backward-word
      bindkey '\e[1;5C' forward-word

      # highlight
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=cyan
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=blue

      # title
      _precmd_title() {
          print -Pn "\e]0;%m: %~\a"
      }
      add-zsh-hook precmd _precmd_title
      _preexec_title() {
          print -Pn "\e]0; - $2\a"
      }
      add-zsh-hook preexec _preexec_title

      # plugin
      zstyle -d ':completion:*' format
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' menu no
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # extra
      function nd() {
          dir="$PWD"
          while  [[ "$dir" != "/" ]]; do
              if [[ -d "$dir/.shell" ]]; then
                  nix develop "path:$dir/.shell"
                  return $?
              fi
              dir=$(dirname "$dir")
          done
          echo ".shell not found"
          return 1
      }

    '';

    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
      ];
    };

    plugins = with pkgs; [
      {
        name = "fzf-tab";
        src = zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "autopair";
        src = zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
    ];
  };

}
