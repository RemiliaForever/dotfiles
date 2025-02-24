{ pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{

  home.packages = with pkgs; [ wpaperd ];
  xdg.configFile = {
    "wpaperd/wallpaper.toml" = {
      source = tomlFormat.generate "wpaperd-wallpaper" {
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
  };
}
