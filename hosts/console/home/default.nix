{ ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
  ];

  remilia = {
    rocm = true;
  };

  # cli
  programs.starship.settings.hostname.style = "purple";

  # wayland
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-1, preferred, auto, 2"
      ];
      exec-once = [
        "sleep 5 && pkill hypridle"
      ];
    };
  };

  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/platform/coretemp.0/hwmon" ];
    input-filename = "temp1_input";
  };
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
}
