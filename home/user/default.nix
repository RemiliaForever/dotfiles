{ pkgs, lib, ... }:

{
  imports = [
    ./option.nix
  ];

  home.sessionVariables = { };

  home = {
    username = "remilia";
    homeDirectory = "/home/remilia";
  };

  home.file.".face".source = ./remilia.jpg;

  home.stateVersion = "24.05";
}
