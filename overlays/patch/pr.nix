final: prev:

{
  # https://github.com/YaLTeR/niri/pull/2609
  # https://github.com/YaLTeR/niri/pull/1791

  # https://github.com/Alexays/Waybar/pull/4895
  waybar = prev.waybar.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/Alexays/Waybar/commit/d929f1a62c764a4cff0897540bc00bf24beb0d5e.patch";
        hash = "sha256-xQxUdw7kXBeGkwFt9Brz7hVOcl2KiimEMPym+0/HCVg=";
      })
      # not upstream yet: mpris reset the display-wide GTK tooltip timer on
      # every update, so a sub-500ms interval killed tooltips for the whole bar
      ./waybar/mpris-tooltip.patch
    ];
  });
}
