{ lib, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
  ];

  home.packages = [
  ];

  # cli
  programs.starship.settings.format = lib.mkForce "wsl $directory $character";
  programs.zsh.shellAliases = {
    s = ''rsync -aP --delete "$PWD/" "/mnt/c/Users/''${PWD#/home/}/" --exclude ".git" --exclude ".direnv" --exclude "build"'';
    sb = ''rsync -aP --delete "$PWD/" "/mnt/c/Users/''${PWD#/home/}/" --exclude ".git" --exclude ".direnv"'';
  };

  home.sessionVariables = {
  };
}
