# QQMusic on a current Electron.
#
# Seven files inside the official app.asar are not stored as plain text, and only
# the binary that ships with it produces that form, so the build runs it (see
# extract-sources.js) rather than taking a prepared copy from anywhere else. The result
# runs on electron_43 -- whose Chromium, unlike Electron 8's, can render the
# variable CJK fonts NixOS ships, so the client is no longer full of tofu
# boxes.
{
  lib,
  stdenvNoCC,
  official,
  fetchurl,
  asar,
  prettier,
  runCommandCC,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron_43,
  fontconfig,
}:

let
  # Named in the imperative, like git format-patch. Order matters: each is
  # generated against the tree the previous ones produced.
  patches = [
    ./0001-use-current-electron.patch
    ./0002-stop-logging-credentials.patch
    ./0003-hide-ads-in-webviews.patch
    ./0004-skip-update-check.patch
    ./0005-fix-lyric-offset.patch
    ./0006-fix-media-session-handlers.patch
    ./0007-play-songs-whose-artist-has-no-page.patch
    ./0008-persist-the-play-list.patch
    ./0009-reuse-the-audio-element.patch
    ./0010-fix-cdn-failover.patch
    ./0011-bound-track-advance.patch
    ./0012-play-songs-with-contradictory-rights.patch
    ./0013-explain-refusals-instead-of-skipping.patch
    ./0014-pick-audio-quality.patch
    ./0015-open-other-peoples-playlists.patch
    ./0016-keep-loading-until-the-playlist-arrives.patch
    ./0017-drop-the-dead-screensaver-watcher.patch
    ./0018-prime-the-media-session.patch
    ./0019-restore-playback-state.patch
    ./0020-quit-when-the-window-closes.patch
    ./0021-open-recommend.patch
  ];

  # See mpris-name.c: makes the client show up on D-Bus as qqmusic, not chromium.
  mprisName = runCommandCC "qqmusic-mpris-name" { } ''
    mkdir -p $out/lib
    $CC -shared -fPIC -O2 -o $out/lib/libqqmusic-mpris-name.so ${./mpris-name.c}
  '';

  electronRemote = fetchurl {
    url = "https://registry.npmjs.org/@electron/remote/-/remote-2.1.3.tgz";
    hash = "sha256-KsTGJcXJIKhLeAtKmBiCusCu8qSIj8mAdCrtJ24wZ4I=";
  };

  app = stdenvNoCC.mkDerivation {
    pname = "qqmusic-app";
    inherit (official) version;

    dontUnpack = true;

    nativeBuildInputs = [
      asar
      prettier
    ];

    buildPhase = ''
      runHook preBuild

      asar extract ${official}/opt/resources/app.asar app
      cp -r --no-preserve=mode ${official}/opt/resources/app.asar.unpacked/. app/

      mkdir -p app/node_modules/@electron/remote
      tar xzf ${electronRemote} -C app/node_modules/@electron/remote --strip-components=1

      ELECTRON_RUN_AS_NODE=1 ${official}/opt/qqmusic \
        ${./extract-sources.js} ${official}/opt/resources/app.asar app

      # main.js is one 1.1MB line as shipped, which no patch could describe.
      # Formatting first also makes the installed sources readable.
      prettier --write --no-config --parser babel --log-level warn app/*.js

      # Every renderer module is the string argument to an eval(), so a patch
      # could only replace whole 100KB lines. Explode them into real files and
      # fold them back afterwards (see webpack-eval.js).
      ELECTRON_RUN_AS_NODE=1 ${official}/opt/qqmusic \
        ${./webpack-eval.js} unwrap app modules

      for p in ${lib.escapeShellArgs (map (p: "${p}") patches)}; do
        echo "applying $(basename "$p" | cut -d- -f2-)"
        patch -p1 --batch --forward --no-backup-if-mismatch -i "$p"
      done

      ELECTRON_RUN_AS_NODE=1 ${official}/opt/qqmusic \
        ${./webpack-eval.js} rewrap app modules

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r app/. $out/
      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "qqmusic";
  inherit (official) version;

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    ln -s ${app} $out/share/qqmusic
    cp -r ${official}/share/icons $out/share/

    # font-list, which the client uses to enumerate fonts, shells out to fc-list.
    makeWrapper ${lib.getExe electron_43} $out/bin/qqmusic \
      --add-flags $out/share/qqmusic \
      --prefix PATH : ${lib.makeBinPath [ fontconfig ]} \
      --set LD_PRELOAD ${mprisName}/lib/libqqmusic-mpris-name.so

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "qqmusic";
      desktopName = "QQMusic";
      exec = "qqmusic %U";
      terminal = false;
      icon = "qqmusic";
      startupWMClass = "qqmusic";
      comment = "Tencent QQMusic";
      categories = [ "AudioVideo" ];
      extraConfig = {
        "Name[zh_CN]" = "QQ音乐";
        "Comment[zh_CN]" = "腾讯QQ音乐";
      };
    })
  ];

  passthru.app = app;

  meta = {
    description = "Tencent QQMusic, repackaged from the official release to run on a current Electron";
    homepage = "https://y.qq.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    # The extraction step runs the official x86_64 binary, so the build cannot cross.
    platforms = [ "x86_64-linux" ];
    mainProgram = "qqmusic";
  };
}
