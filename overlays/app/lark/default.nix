{
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gnutls,
  gtk3,
  lib,
  libGL,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libappindicator-gtk3,
  libcxx,
  libdbusmenu,
  libdrm,
  libgcrypt,
  libglvnd,
  libnotify,
  libpulseaudio,
  libuuid,
  libxcb,
  libxkbcommon,
  libxkbfile,
  libxshmfence,
  makeShellWrapper,
  libgbm,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  pixman,
  stdenv,
  systemd,
  wayland,
  xdg-utils,

  # for custom command line arguments, e.g. "--use-gl=desktop"
  commandLineArgs ? "",
}:

let
  sources = {
    # NOTE: override
    x86_64-linux = fetchurl {
      url = "https://sf16-sg.larksuitecdn.com/obj/lark-artifact-storage/967dd7e4/Lark-linux_x64-7.59.12.deb";
      sha256 = "sha256-Oa5tCn2l4zJzafzoxLfAZVXu0zWILKv+DeWJsQRsZtI=";
    };
  };

  supportedPlatforms = [
    "x86_64-linux"
  ];

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    gnutls
    libGL
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libcxx
    libdbusmenu
    libdrm
    libgcrypt
    libglvnd
    libnotify
    libpulseaudio
    libuuid
    libxcb
    libxkbcommon
    libxkbfile
    libxshmfence
    libgbm
    nspr
    nss
    pango
    pciutils
    pipewire
    pixman
    stdenv.cc.cc
    systemd
    wayland
    xdg-utils
  ];
in
stdenv.mkDerivation {
  version = "7.59.12"; # NOTE: override
  pname = "lark";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    dpkg
  ];

  buildInputs = [
    gtk3

    # for autopatchelf
    alsa-lib
    cups
    libXdamage
    libXtst
    libdrm
    libgcrypt
    libpulseaudio
    libxshmfence
    libgbm
    nspr
    nss
  ];

  dontUnpack = true;
  installPhase = ''
    # This deb file contains a setuid binary,
    # so 'dpkg -x' doesn't work here.
    dpkg --fsys-tarfile $src | tar --extract
    mkdir -p $out
    mv usr/share $out/
    mv opt/ $out/

    substituteInPlace $out/share/applications/bytedance-lark.desktop \
      --replace /usr/bin/bytedance-lark-stable $out/opt/bytedance/lark/bytedance-lark

    # Wrap lark and vulcan
    # lark is the main executable, vulcan is the builtin browser
    for executable in $out/opt/bytedance/lark/{lark,vulcan/vulcan}; do
      # FIXME: Add back NIXOS_OZONE_WL support once upstream fixes the crash on native Wayland (see #318035)
      wrapProgram $executable \
        --prefix XDG_DATA_DIRS    :  "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_LIBRARY_PATH  :  ${rpath}:$out/opt/bytedance/lark:${addDriverRunpath.driverLink}/share \
        ${lib.optionalString (
          commandLineArgs != ""
        ) "--add-flags ${lib.escapeShellArg commandLineArgs}"}
    done

    mkdir -p $out/share/icons/hicolor
    base="$out/opt/bytedance/lark"
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      ln -s $base/product_logo_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/bytedance-lark.png
    done

    mkdir -p $out/bin
    ln -s $out/opt/bytedance/lark/bytedance-lark $out/bin/bytedance-lark
  '';

  meta = {
    description = "All-in-one collaboration suite";
    homepage = "https://www.lark.cn/en/";
    downloadPage = "https://www.lark.cn/en/#en_home_download_block";
    license = lib.licenses.unfree;
    platforms = supportedPlatforms;
    maintainers = with lib.maintainers; [ billhuang ];
    mainProgram = "bytedance-lark";
  };
}
