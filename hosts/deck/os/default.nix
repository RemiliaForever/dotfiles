{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steam.nix
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
    steam.enable = true;
    steam.autoStart = true;
  };
}
