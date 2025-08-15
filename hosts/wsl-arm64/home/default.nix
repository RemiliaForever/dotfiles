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
    s = "rsync -avh --delete /home/remilia/Workspace/ /mnt/c/Users/remilia/Workspace/ --exclude \".git\" --exclude \"build\"";
  };

  home.sessionVariables = {
  };
}
