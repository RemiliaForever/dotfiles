{ aagl, ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./zfs.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/virtualisation.nix
    ../../../nixos/wireshark.nix

    aagl.nixosModules.default
  ];

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  # aaglx
  nix.settings = aagl.nixConfig;
  programs.honkers-railway-launcher.enable = true;
}
