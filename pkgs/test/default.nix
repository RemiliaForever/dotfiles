{
  pkgs ? import <nixpkgs> { },
  lib,
}:

pkgs.wechat-uos.overrideAttrs (old: rec {
  runScript = pkgs.writeShellScript "wechat-uos-launcher" ''
    export QT_QPA_PLATFORM=xcb
    export QT_SCALE_FACTOR=2
    export LD_LIBRARY_PATH=${lib.makeLibraryPath wechat-uos-runtime}

    if [[ ''${XMODIFIERS} =~ fcitx ]]; then
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
    elif [[ ''${XMODIFIERS} =~ ibus ]]; then
      export QT_IM_MODULE=ibus
      export GTK_IM_MODULE=ibus
      export IBUS_USE_PORTAL=1
    fi

    ${wechat.outPath}/opt/apps/com.tencent.wechat/files/wechat
  '';

})
