{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
  ];

  home.packages = with pkgs; [
    waypipe
  ];

  # cli
  programs.starship.settings.hostname.style = "purple";

  # wayland
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-1, preferred, auto, 2"
      ];
      exec-once = [
      ];
    };
  };
}
