{ aagl, ... }:

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
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      #extraPackages = with pkgs; [ ];
    };
  };
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # steam
  jovian = {
    steam.enable = true;
    steam.autoStart = true;
    steamos.enableMesaPatches = false;
  };

  # aaglx
  nix.settings = aagl.nixConfig;
  programs.honkers-railway-launcher.enable = true;
}
