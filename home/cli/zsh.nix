{ ... }:

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
      vims = "vim --servername VIM";

      cb = "nice -n 19 cmake --build build -j";
      ct = "ctest --test-dir build";
    };

    initContent = ''
      # extra
      function nd() {
          dir="$PWD"
          while  [[ "$dir" != "/" ]]; do
              if [[ -d "$dir/.shell" ]]; then
                  nix develop "$dir/.shell"
                  return $?
              fi
              dir=$(dirname "$dir")
          done
          echo ".shell not found"
          return 1
      }

      bindkey '\e[1;5D' backward-word
      bindkey '\e[1;5C' forward-word

      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=cyan
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=blue
    '';

    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
      ];
    };
  };

}
