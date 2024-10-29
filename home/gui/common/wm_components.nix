{ pkgs, ... }:

let
  swww-control = pkgs.writers.writePython3Bin "swww-control" { } ''
    import os
    import time

    if __name__ == '__main__':
        dir = os.path.expanduser('~/.background')
        for root, dirs, files in os.walk(dir, followlinks=True):
            for file in files:
                os.system(' '.join([
                    f'swww img "{root}/{file}"',
                    '--transition-type fade',
                    '--transition-fps 30',
                    '--transition-duration 1',
                ]))
                time.sleep(10 * 60)
  '';
in
{
  home.packages = with pkgs; [
    hypridle
    hyprlock
    mako
    swww
    swww-control
  ];

  home.file = {
    ".config/hypr/hypridle.conf" = {
      text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = loginctl lock-session
            after_sleep_cmd = hyprctl dispatch dpms on
        }

        listener {
            timeout = 600
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }

        listener {
            timeout = 1800
            on-timeout = systemctl suspend
        }
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
