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
      share = true;
      size = 65536;
    };

    syntaxHighlighting.enable = true;

    autocd = true;
    autosuggestion.enable = true;
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
    '';
  };

}
