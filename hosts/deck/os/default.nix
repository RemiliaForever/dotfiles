{ pkgs, aagl, ... }:

{
  imports = [
    ./hardware.nix

    ../../../nixos/common
    ../../../nixos/gui
    ../../../nixos/steamos.nix

    aagl.nixosModules.default
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

  # aaglx
  nix.settings = aagl.nixConfig;
  programs.honkers-railway-launcher.enable = true;
}
