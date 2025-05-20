{ pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/opt/aagl.nix
    ../../../nixos/opt/spotify.nix
    ../../../nixos/opt/steamos.nix
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
  # https://github.com/Jovian-Experiments/Jovian-NixOS/issues/497
  services.xserver.displayManager.startx.enable = lib.mkForce false;
}
