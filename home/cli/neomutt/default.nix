{ pkgs, ... }:

{
  imports = [
    ./accounts.nix
    ./binds.nix
    ./color.nix
    ./settings.nix
  ];
}
