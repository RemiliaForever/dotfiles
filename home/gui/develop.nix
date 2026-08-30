{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wayvnc
    remmina
    kicad
    openscad
    virt-manager
    libreoffice-qt6
  ];
}
