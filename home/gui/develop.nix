{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wayvnc
    kdePackages.krdc
    kicad
    openscad
    virt-manager
    libreoffice-qt6-fresh
  ];
}
