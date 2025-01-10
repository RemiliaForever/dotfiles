{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freerdp3
    kcachegrind
    kicad
    openscad
    texliveFull
  ];
}
