{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  testers,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  # upstream uses the default suffix for x64 and an `-aarch64` suffix otherwise
  suffix = selectSystem {
    "x86_64-linux" = "";
    "aarch64-linux" = "-aarch64";
  };

  hash = selectSystem {
    "x86_64-linux" = "sha256-6ajvuyFga+IL9eLqNKCPphdVwRxpFQSQOy54HGreEqw=";
    "aarch64-linux" = "sha256-769vjedw4TzXPak1U/ls69sIiyow3057VGAADBCXtsU=";
  };
in

stdenv.mkDerivation (finalAttrs: rec {
  pname = "kotlin-lsp";
  version = "262.9593.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}${suffix}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    zlib
    stdenv.cc.cc.lib # for libgcc_s
  ];

  dontBuild = true;

  installPhase = ''
    chmod +x ./kotlin-lsp.sh ./bin/intellij-server
    chmod +x ./jbr/bin/java

    # kotlin-lsp is headless so we can reduce the auto-patchelf dependencies
    rm ./jbr/lib/lib{awt_{wl,x}awt,jawt,fontmanager,jsound,{wl,}splashscreen}*

    # retain original directory structure to reduce necessary patching
    mkdir -p $out/opt/kotlin-lsp $out/bin
    cp -r ./* $out/opt/kotlin-lsp
    ln -s "$out/opt/kotlin-lsp/kotlin-lsp.sh" "$out/bin/kotlin-lsp"
  '';

  passthru.tests.help = testers.testVersion {
    # not checking the version but this checks the JVM classpath and statically (i.e. at import time) loaded native libraries
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} --help";
    version = "Usage: ${finalAttrs.meta.mainProgram}";
  };

  meta = {
    description = "Official Kotlin language server based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin.";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    changelog = "https://github.com/Kotlin/kotlin-lsp/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ axka ];
    platforms = lib.platforms.linux; # macOS people, feel free to expand this!
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "kotlin-lsp";
  };
})
