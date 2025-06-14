{ pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./fan.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/opt/aagl.nix
    ../../../nixos/opt/spotify.nix
    ../../../nixos/opt/steamos.nix
  ];

  # gpu
  hardware = {
    amdgpu = {
      opencl.enable = true;
      overdrive.enable = true;
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

  ## steam
  #jovian = {
  #  steam.enable = true;
  #  steam.autoStart = true;
  #  steamos.enableDefaultCmdlineConfig = false;
  #  steamos.enableMesaPatches = false;
  #};
  ## https://github.com/Jovian-Experiments/Jovian-NixOS/issues/497
  #services.xserver.displayManager.startx.enable = lib.mkForce false;
}
