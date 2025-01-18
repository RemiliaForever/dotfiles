{ pkgs, ... }:

{
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "/home/remilia/.background";
        duration = "15min";
        sorting = "random";
        mode = "stretch";
        transition-time = 1000;
      };
    };
  };
}
