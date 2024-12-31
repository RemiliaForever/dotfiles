{ ... }:

{
  imports = [
    ./ddns.nix
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam
    ../../../nixos/virtualisation.nix
  ];

  boot = {
    kernelParams = [ ];
    tmp.useTmpfs = true;
  };
}
