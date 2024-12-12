{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kcachegrind
    kicad
    openscad
    tig

    virt-manager

    texliveFull
  ];
}
