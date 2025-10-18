{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
    (import ../../../home/gui/multimedia.nix {
      pkgs = pkgs;
      cudaSupport = true;
    })
  ];

  home.packages = with pkgs; [
    # deluge
    baidupcs-go

    lark
    qq
    wechat
    discord
    slack
    telegram-desktop
  ];

  # cli
  programs.starship.settings.hostname.style = "yellow";
  programs.zsh.initContent = ''
    # sync
    sb() {
        cmd="rsync -v -aP --mkpath --delete $PWD/$1/ ''${S_HOST:-win}:''${PWD#/home/remilia/}/$1/ --exclude .git --exclude .cache --exclude .direnv ''${@:2}"
        echo "$cmd"
        eval "$cmd"
    }
    s() {
        sb "$1" ''${@:2} --exclude build
    }
  '';

  # wayland
  wayland.windowManager.hyprland = {
    autoStart = true;
    settings = {
      monitor = [
        "HDMI-A-1, 3840x2160@160, 0x0, 2, vrr, 1"
        "DP-1, 3840x2160@60, 1920x0, 2, vrr, 1"
      ];

      exec-once = [
        "[workspace 8 silent] sleep 3 && firefox"

        "[workspace 9 silent] sleep 5 && wechat"
        "[workspace 9 silent] sleep 5 && qq"
        "[workspace 9 silent] sleep 5 && Telegram"
        "[workspace 9 silent] sleep 5 && discord"
        "[workspace 10 silent] sleep 5 && bytedance-lark"

        "[workspace 11 silent] sleep 8 && spotify"
        "[workspace 11 silent] sleep 8 && steam"
      ];
    };
  };
  programs.waybar = {
    mainOutput = "HDMI-A-1";
    temperature = {
      hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
      input-filename = "temp1_input";
    };
    settings = {
      mainBar."hyprland/workspaces".format-icons = {
        "1" = " ";
        "2" = " ";
        "3" = " ";
      };
      altBar."hyprland/workspaces".format-icons = {
        "8" = "󰈹 ";
        "9" = " ";
        "10" = "󰭹 ";
        "11" = " ";
        "12" = " ";
      };
    };
  };
}
