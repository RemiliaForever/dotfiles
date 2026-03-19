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

  home.sessionVariables = {
  };
}
