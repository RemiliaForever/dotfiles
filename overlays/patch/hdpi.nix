final: prev:

{
  bambu-studio = prev.bambu-studio.overrideAttrs (old: {
    preFixup = ''
      ${old.preFixup}
      gappsWrapperArgs+=(
          --set GTK_IM_MODULE fcitx
          --set GDK_SCALE 2
      )
    '';
  });
}
