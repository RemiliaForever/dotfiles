{ pkgs, aagl, ... }:

{
  imports = [
    ./hardware.nix
    ./fan.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steamos.nix

    aagl.nixosModules.default
  ];

  # gpu
  hardware = {
    amdgpu = {
      opencl.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
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
