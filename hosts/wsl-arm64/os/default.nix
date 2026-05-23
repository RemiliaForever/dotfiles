{ lib, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default

    ../../../nixos/common
    ../../../nixos/opt/virtualisation.nix

    ./patch.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "remilia";
  wsl.interop.register = true;
  wsl.useWindowsDriver = true;

  # override boot loader
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.grub2-theme.enable = lib.mkForce false;

  # override sops
  system.activationScripts.setupSecrets = lib.mkForce "";
  sops.secrets."hashedPassword".neededForUsers = lib.mkForce false;
  users.users.remilia.hashedPasswordFile = lib.mkForce null;
  users.allowNoPasswordLogin = lib.mkForce true;

  # override services
  services.sing-box.enable = lib.mkForce false;
  services.zerotierone.enable = lib.mkForce false;
  services.openssh.ports = lib.mkForce [ 1022 ];

  # override virtualisation
  virtualisation.libvirtd.enable = lib.mkForce false;
  virtualisation.spiceUSBRedirection.enable = lib.mkForce false;
  boot.binfmt.emulatedSystems = lib.mkForce [
    # "x86_64-linux"
  ];
}
