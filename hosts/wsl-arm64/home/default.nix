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
    s = ''rsync -aP --delete "$PWD/" "/mnt/c/Users/''${PWD#/home/}/" --exclude ".git" --exclude "build"'';
  };

  home.sessionVariables = {
  };
}
