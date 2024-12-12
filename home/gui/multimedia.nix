{ pkgs, ... }:

{
  home.packages = with pkgs; [
    audacity
    bambu-studio
    #blender
    darktable
    kdenlive
    krita
    lmms
    pitivi

    (digikam.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ pkgs.mariadb ];
    }))
  ];
}
