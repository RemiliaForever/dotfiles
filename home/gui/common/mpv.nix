{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
      sub-auto = "fuzzy";
      save-position-on-quit = true;
      osc = "no";
    };
    scripts = with pkgs.mpvScripts; [
      modernx-zydezu
      thumbfast
    ];
    scriptOpts = {
      modernx = {
        vidscale = false;
        scalewindowed = 2.0;
        scalefullscreen = 2.0;
        scaleforcedwindow = 2.0;
      };
    };
  };
}
