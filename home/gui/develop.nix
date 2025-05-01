{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freerdp3
    #kicad
    #openscad
    virt-manager
    libreoffice-qt6-fresh
  ];
}
