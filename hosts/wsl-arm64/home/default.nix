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
    sb = ''rsync -aP --mkpath --delete "$PWD/" "/mnt/c/Users/remilia/''${PWD#/home/remilia/}/" --exclude ".git" --exclude ".cache" --exclude ".direnv"'';
    s = ''sb --exclude "build"'';
  };

  home.sessionVariables = {
  };
}
