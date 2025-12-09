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
    baidupcs-go

    lark
    qq
    wechat
    discord
    slack
    telegram-desktop
  ];

  programs = {
    starship.settings.hostname.style = "yellow";

    zsh = {
      initContent = ''
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
      shellAliases = {
        hrst = "systemctl --user restart waybar wpaperd";
      };
    };

    niri = {
      autoStart = true;
      extraConfig = ''
        // Host Specific Configurations

        // Outputs

        output "HDMI-A-1" {
            mode "3840x2160@119.88"
            scale 2.0
            position x=0 y=0
            variable-refresh-rate
            focus-at-startup
        }

        output "DP-1" {
            mode "3840x2160@59.997"
            scale 2.0
            position x=1920 y=0
        }

        // Named workspaces

        workspace "programming1" {
            open-on-output "HDMI-A-1"
        }
        workspace "programming2" {
            open-on-output "HDMI-A-1"
        }
        workspace "browser" {
            open-on-output "DP-1"
        }
        workspace "lark" {
            open-on-output "DP-1"
        }
        workspace "chat" {
            open-on-output "DP-1"
        }
        workspace "fun" {
            open-on-output "DP-1"
        }


        // Miscellaneous

        spawn-sh-at-startup "sleep 3 && firefox"
        spawn-sh-at-startup "sleep 3 && bytedance-lark"
        spawn-sh-at-startup "sleep 3 && wechat"
        spawn-sh-at-startup "sleep 5 && qq"
        spawn-sh-at-startup "sleep 7 && discord"
        spawn-sh-at-startup "sleep 10 && Telegram"
        spawn-sh-at-startup "sleep 8 && spotify"
        spawn-sh-at-startup "sleep 8 && steam"

        // Window Rules

        window-rule {
            match app-id="^firefox$"

            open-on-workspace "browser"
            default-column-width {}
        }

        window-rule {
            match app-id="^Bytedance-lark$"

            open-on-workspace "lark"
            default-column-width {
                proportion 1.0
            }
        }

        window-rule {
            match app-id="^wechat$"
            match app-id="^QQ$"
            match app-id=r#"^org\.telegram\.desktop$"#
            match app-id="^discord$"

            open-on-workspace "chat"
        }

        window-rule {
            match app-id="^spotify$"
            match app-id="^steam$"

            open-on-workspace "fun"
            default-column-width {
                proportion 0.6
            }
        }

        window-rule {
            match app-id="^wechat$"
            match app-id=r#"^org\.telegram\.desktop$"#
            block-out-from "screencast"
        }
      '';
    };
    waybar = {
      mainOutput = "DP-1";
      temperature = {
        hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
        input-filename = "temp1_input";
      };
      settings = {
        altBar = {
          "niri/workspaces".format-icons = {
            "programming1" = " ";
            "programming2" = " ";
          };
        };
        mainBar = {
          "niri/workspaces".format-icons = {
            "browser" = "󰈹 ";
            "lark" = "󱗆 ";
            "chat" = " ";
            "fun" = " ";
          };
        };
      };
    };
  };
}
