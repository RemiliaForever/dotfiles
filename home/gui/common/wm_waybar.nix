{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "wireplumber"
          "network"
          "cpu"
          "memeory"
          "temperature"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "active" = " ";
            "default" = " ";
          };
        };
        "hyprland/window" = {
          separate-outputs = true;
          format = "{title:.48}";
        };
        "tray" = {
          icon-size = 14;
          spacing = 5;
        };
      };
    };
    style = ''
      * {
          min-height: 0;
          font-family: monospace;
          font-size: 13px;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background: transparent;
      }

      tooltip {
          border: 2px solid rgba(89, 89, 89, 0.85);
          border-radius: 8px;
          background: rgba(33, 33, 33, 0.85);
      }

      tooltip label {
          color: #f5e0dc;
      }

      #workspaces, #window, #mpris, #tray, #wireplumber, #network, #cpu, #memory, #temperature, #battery, #clock {
          border: 2px solid rgba(89, 89, 89, 0.85);
          border-radius: 8px;
          margin-top: 5px;
          margin-right: 5px;
          padding: 0px 5px 0px 5px;
          background: rgba(33, 33, 33, 0.85);
      }

      #workspaces {
          margin-left: 5px;
      }
      #workspaces button {
          color: #f5e0dc;
      }
      #workspaces button.active {
          color: #89b4fa;
      }
      #workspaces button.urgent {
          color: #f38ba8;
      }

      #window {
          color: #cba6f7;
      }
      window#waybar.empty #window {
          opacity: 0;
          margin: 0;
          padding: 0;
          border: none;
      }

      #mpris {
          color: #fab387;
      }

      #tray {
          color: #cba6f7;
      }
      #tray * {
          margin: unset;
          padding: unset;
          font-family: unset;
          font-size: unset;
      }

      #wireplumber {
          color: #94e2d5;
      }

      #network {
          color: #89b4fa;
      }

      #cpu {
          color: #f2cdcd;
      }

      #memory {
          color: #f38ba8;
      }

      #temperature{
          color: #f9e2af;
      }

      #battery {
          color: #89dceb;
      }

      #clock {
          margin-right: 5px;
          color: #b4befe;
      }
    '';
  };
}
