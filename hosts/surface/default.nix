{ pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-pro-intel

    ../../nixos/common
    ../../nixos/gui
    ../../nixos/steam
  ];

  # boot = { kernelParams = [ ]; };

  zramSwap.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "leftcontrol";
          leftcontrol = "capslock";
        };
      };
    };
  };
}
