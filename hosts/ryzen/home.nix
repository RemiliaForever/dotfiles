{ pkgs, ... }:

{
  imports = [
    ../../home/user
    ../../home/cli
    ../../home/gui/common
    ../../home/gui/develop.nix
    ../../home/gui/multimedia.nix
  ];

  home.packages = with pkgs; [
    deluge
  ];

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-1, 3840x2160, 1920x0, 2"
        "DP-3, 3840x2160, 0x0, 2"
      ];

      exec-once = [
        "[workspace 3 silent] firefox"
        "[workspace 6 silent] bytedance-feishu"
        "[workspace 6 silent] wechat-uos"
        "[workspace 10 silent] netease-cloud-music-gtk4"
      ];
    };
  };
}
