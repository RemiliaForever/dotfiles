{ mypkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
  ];

  home.packages = [
    mypkgs.feishu
  ];

  # wayland
  programs.bash.profileExtra = ''
    if uwsm check may-start -q; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/platform/coretemp.0/hwmon" ];
    input-filename = "temp1_input";
  };
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
}
