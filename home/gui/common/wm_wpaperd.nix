{ ... }:

{
  programs.wpaperd = {
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
}
