{
  pkgs,
  lib,
  ...
}:

{

  home.packages = with pkgs; [
    hypridle
    hyprlock
    hyprshot
  ];

  xdg.configFile = {
    "hypr/hypridle.conf".text = lib.hm.generators.toHyprconf {
      attrs = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 900;
            on-timeout = "hyprctl dispatch dpms off && wpaperctl pause";
            on-resume = "hyprctl dispatch dpms on && wpaperctl resume";
          }
        ];
      };
    };

    "hypr/hyprlock.conf".text = lib.hm.generators.toHyprconf {
      attrs = {
        input-field = {
          fade_on_empty = false;
        };
        background = {
          color = "rgb(23, 39, 41)";
        };
      };
    };
  };

  services.mako = {
    enable = true;

    settings = {
      default-timeout = 10000;
      layer = "overlay";
      sort = "-time";

      background-color = "#212121dd";
      border-radius = 8;
      border-size = 2;
      markup = 1;

      "urgency=low".border-color = "#595959ee";
      "urgency=normal".border-color = "#33ccffee";
      "urgency=high" = {
        border-color = "#f38ba8ee";
        default-timeout = 0;
      };

      on-notify = "exec ${pkgs.mpv}/bin/mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/bell.oga";
    };
  };

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "/home/remilia/.background";
        sorting = "random";
        queue-size = 3;
        mode = "center";
        duration = "10min";
        transition-time = 1000;
        group = 1;
      };
    };
  };

  # authentication
  services.hyprpolkitagent.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common.default = "hyprland";
    };
  };
}
