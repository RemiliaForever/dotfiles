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
  programs.niri.extraConfig = ''
    // Host Specific Configurations

    // Outputs

    output "HDMI-A-1" {
        mode "4096x2160@60"
        scale 2.0
    }
  '';
}
