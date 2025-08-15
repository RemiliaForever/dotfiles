{ lib, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default

    ../../../nixos/common
  ];

  wsl.enable = true;
  wsl.defaultUser = "remilia";

  # override
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.grub2-theme.enable = lib.mkForce false;
  services.sing-box.enable = lib.mkForce false;
  services.zerotierone.enable = lib.mkForce false;
  services.openssh.enable = lib.mkForce false;
}
