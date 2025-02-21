{ aagl, ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam.nix
    ../../../nixos/virtualisation.nix
    ../../../nixos/wireshark.nix

    aagl.nixosModules.default
  ];

  # aaglx
  nix.settings = aagl.nixConfig;
  programs.honkers-railway-launcher.enable = true;
}
