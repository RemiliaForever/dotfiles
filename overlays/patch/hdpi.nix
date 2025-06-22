final: prev:

{
  feishu = prev.feishu.overrideAttrs (old: {
    installPhase = ''
      ${old.installPhase}
      for executable in $out/opt/bytedance/feishu/{feishu,vulcan/vulcan}; do
          wrapProgram $executable \
            --set GTK_IM_MODULE fcitx \
            --set GDK_SCALE 2
      done
    '';
  });

  lark = prev.lark.overrideAttrs (old: {
    installPhase = ''
      ${old.installPhase}
      for executable in $out/opt/bytedance/lark/{lark,vulcan/vulcan}; do
          wrapProgram $executable \
            --set GTK_IM_MODULE fcitx \
            --set GDK_SCALE 2
      done
    '';
  });

  wechat-uos = prev.wechat-uos.override {
    buildFHSEnv =
      args:
      final.buildFHSEnv (
        args
        // {
          runScript = final.writeShellScript "wechat-uos-launcher-hdpi" ''
            export GTK_IM_MODULE=fcitx
            export QT_SCALE_FACTOR=2
            ${args.runScript}
          '';
        }
      );
  };

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
