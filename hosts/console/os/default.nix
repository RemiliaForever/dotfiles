{ config, aagl, ... }:

{
  imports = [
    ./hardware.nix
    ./fan.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam.nix

    aagl.nixosModules.default
  ];

  # gpu
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # steam
  jovian = {
    steam.enable = true;
    steam.autoStart = true;
    steamos.enableDefaultCmdlineConfig = false;
    steamos.enableMesaPatches = false;
  };

  # aaglx
  nix.settings = aagl.nixConfig;
  programs.honkers-railway-launcher.enable = true;
}
