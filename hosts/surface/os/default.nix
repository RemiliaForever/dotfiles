{ pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-pro-intel

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/wireshark.nix
  ];

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
    };
  };

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
}
