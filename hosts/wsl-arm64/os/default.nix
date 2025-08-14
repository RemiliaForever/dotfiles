{ lib, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default

    ../../../nixos/common
  ];

  wsl.enable = true;
  wsl.defaultUser = "remilia";
  boot.loader.grub.enable = lib.mkForce false;
}
