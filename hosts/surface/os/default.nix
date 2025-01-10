{ pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-pro-intel

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam
    ../../../nixos/wireshark.nix
  ];

  # gpu
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
    intel-gpu-tools.enable = true;
  };

  # keyd
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

  # steam
  jovian.steam.autoStart = true;
}
