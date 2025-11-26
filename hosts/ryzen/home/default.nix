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
  programs.zsh.shellAliases = {
    hrst = "systemctl --user restart waybar wpaperd";
  };

  # wayland
  wayland.windowManager.hyprland = {
    autoStart = true;
    settings = {
      monitor = [
        "HDMI-A-1, 3840x2160@160, 0x0, 2, vrr, 1"
        "DP-1, 3840x2160@60, 1920x0, 2, vrr, 1"
      ];

      windowrule = [
        "workspace 8, noinitialfocus, class:firefox"
        "workspace 9, noinitialfocus, class:Bytedance-lark"
        "workspace 10, noinitialfocus, class:wechat|QQ|org.telegram.desktop|discord"
        "workspace 11, noinitialfocus, class:spotify"
        "workspace 12, noinitialfocus, class:steam"
      ];

      exec-once = [
        "sleep 3 && firefox"

        "sleep 5 && wechat"
        "sleep 5 && qq"
        "sleep 5 && Telegram"
        "sleep 5 && discord"
        "sleep 5 && bytedance-lark"

        "sleep 8 && spotify"
        "sleep 8 && steam"
      ];
    };
  };
  programs.waybar = {
    mainOutput = "DP-1";
    temperature = {
      hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
      input-filename = "temp1_input";
    };
    settings = {
      altBar = {
        "hyprland/workspaces".format-icons = {
          "1" = " ";
          "2" = " ";
          "3" = " ";
        };
      };
      mainBar = {
        "hyprland/workspaces".format-icons = {
          "8" = "󰈹 ";
          "9" = "󱗆 ";
          "10" = " ";
          "11" = " ";
          "12" = " ";
        };
      };
    };
  };
}
