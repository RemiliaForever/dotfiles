{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hypridle
    hyprlock
  ];

  home.file = {
    ".config/hypr/hypridle.conf" = {
      text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = loginctl lock-session
            after_sleep_cmd = hyprctl dispatch dpms on
        }

        #listener {
        #    timeout = 600
        #    on-timeout = loginctl lock-session
        #}

        listener {
            timeout = 1800
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }

        #listener {
        #    timeout = 7200
        #    on-timeout = systemctl suspend
        #}
      '';
    };

    ".config/hypr/hyprlock.conf" = {
      text = ''
        input-field {
          monitor =
          fade_on_empty = false
        }

        background {
          color = rgb(23, 39, 41)
        }
      '';
    };
  };
}
