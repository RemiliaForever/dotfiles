{ pkgs, ... }:

{
  imports = [
    ../../home/user
    ../../home/cli
    ../../home/gui/common
    ../../home/gui/develop.nix
  ];
}
