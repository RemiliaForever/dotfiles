{
  pkgs,
  mypkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    hypridle
    hyprlock
    mypkgs.hyprshot
    #hyprpolkitagent # FIX: new nixpkgs
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
            timeout = 1800;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
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
