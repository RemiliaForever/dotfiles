{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
  ];
  # wayland
  programs.bash.profileExtra = ''
    if uwsm check may-start -q; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';
  wayland.windowManager.hyprland = {
    settings.exec-once = [
      "nextcloud"
    ];
  };
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/platform/coretemp.0/hwmon" ];
    input-filename = "temp1_input";
  };
}
