{ pkgs, ... }:

{
  home.packages = with pkgs; [
    audacity
    bambu-studio
    blender
    darktable
    digikam
    kdenlive
    krita
    lmms
    pitivi
  ];
}
