{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
    ../../../home/gui/multimedia.nix
  ];

  home.packages = with pkgs; [
    deluge
    #baidunetdisk

    feishu
    wechat-uos
    #qq
    #discord
  ];

  remilia = {
    rocm = true;
  };

  # cli
  programs.starship.settings.hostname.style = "yellow";

  # wayland
  programs.bash.profileExtra = ''
    if uwsm check may-start -q; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-1, 3840x2160, 1920x0, 2"
        "DP-2, 3840x2160, 0x0, 2"
      ];

      exec-once = [
        "[workspace 8 silent] sleep 5 && firefox"
        "[workspace 1 silent] sleep 5 && bytedance-feishu"
        "[workspace 1 silent] sleep 5 && wechat-uos"
        "[workspace 5 silent] sleep 5 && netease-cloud-music-gtk4"
      ];
    };
  };
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
    input-filename = "temp1_input";
  };
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
}
