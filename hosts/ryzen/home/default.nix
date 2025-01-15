{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
    ../../../home/gui/multimedia.nix
  ];

  remilia = {
    cuda = true;
    rocm = true;
  };

  home.packages = with pkgs; [
    deluge
  ];

  # wayland
  programs.bash.profileExtra = ''
    if uwsm check may-start -q; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-4, 3840x2160, 1920x0, 2"
        "DP-5, 3840x2160, 0x0, 2"
      ];

      exec-once = [
        "[workspace 8 silent] firefox"
        "[workspace 1 silent] bytedance-feishu"
        "[workspace 1 silent] wechat-uos"
        "[workspace 5 silent] netease-cloud-music-gtk4"
        "nextcloud"
      ];
    };
  };
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
    input-filename = "temp1_input";
  };
}
