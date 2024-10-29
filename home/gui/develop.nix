{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kcachegrind
    kicad
    openscad
    texliveFull
    virt-manager
  ];
}
