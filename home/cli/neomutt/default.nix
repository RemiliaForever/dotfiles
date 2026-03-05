{ pkgs, lib, ... }:

{
  imports = [
    ./accounts.nix
    ./binds.nix
    ./color.nix
    ./settings.nix
  ];

  home.activation.neomutt = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/mkdir -p $HOME/.cache/neomutt/messages
  '';

  programs.zsh.shellAliases = {
    mutt-koumakan = "neomutt -e 'source ~/.config/neomutt/koumakan'";
    mutt-nexa = "neomutt -e 'source ~/.config/neomutt/nexa4ai'";
  };
}
