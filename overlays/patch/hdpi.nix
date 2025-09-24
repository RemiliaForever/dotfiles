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

  wechat = prev.wechat.overrideAttrs (old: {
    # builtins.trace "Overriding wechat for HDPI: ${final.lib.generators.toPretty { } old}" {
    nativeBuildInputs = [ final.makeWrapper ];
    buildCommand = ''
      ${old.buildCommand}

      wrapProgram $out/bin/wechat \
        --set QT_IM_MODULE fcitx \
        --set QT_SCALE_FACTOR 2
    '';
  });

  steam = prev.steam.override {
    extraEnv = {
      GDK_SCALE = "2";
    };
  };
}
