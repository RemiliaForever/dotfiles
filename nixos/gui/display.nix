{ pkgs, pkgs-unstable, ... }:

{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "us";
    displayManager.startx.enable = true;
  };

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [ ];
}
