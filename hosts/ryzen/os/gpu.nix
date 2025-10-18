{ config, ... }:

{
  hardware = {
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.xserver.videoDrivers = [
    "nvidia"
  ];
}
