{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam
  ];

  # gpu
  hardware = {
  };
  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  # steam
  jovian = {
    devices.steamdeck.enable = true;
    steam.autoStart = true;
    steamos = {
      enableDefaultCmdlineConfig = true;
      enableEarlyOOM = true;
      enableProductSerialAccess = true;
      enableSysctlConfig = true;
      enableVendorRadv = true;
      enableZram = true;
    };
  };
}
