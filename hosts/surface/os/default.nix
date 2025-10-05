{ pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-pro-intel

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/opt/spotify.nix
    ../../../nixos/opt/wireshark.nix
  ];

  services.zerotierone.enableNexa = true;

  # surface kernel
  hardware.microsoft-surface.kernelVersion = "stable";

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      PLATFORM_PROFILE_ON_AC = "balanced-performance";
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 95;

      PLATFORM_PROFILE_ON_BAT = "balanced";
      CPU_DRIVER_OPMODE_ON_BAT = "active";
      CPU_HWP_DYN_BOOST_ON_BAT = 1;
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 75;
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
