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
}
