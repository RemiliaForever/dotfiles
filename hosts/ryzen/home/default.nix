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
    baidupcs-go

    feishu
    wechat-uos
    qq
    discord

    wiliwili
  ];

  remilia = {
    cuda = true;
  };

  # cli
  programs.starship.settings.hostname.style = "yellow";

  # wayland
  programs.bash.profileExtra = ''
    if uwsm check may-start -q && uwsm select; then
        exec uwsm start default
    fi
  '';
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-1, 3840x2160, 0x0, 2"
      ];

      exec-once = [
        "[workspace 3 silent] sleep 5 && firefox"
        "[workspace 4 silent] sleep 5 && wechat-uos"
        "[workspace 4 silent] sleep 5 && qq"
        "[workspace 5 silent] sleep 5 && netease-cloud-music-gtk4"
        "[workspace 5 silent] sleep 5 && steam"

        "sleep 5 && pkill hypridle"
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
