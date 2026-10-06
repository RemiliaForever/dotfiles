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

  platform = selectSystem {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
  };

  hash = selectSystem {
    "x86_64-linux" = "sha256-Je5qZT7Nerdlq1UL+llelxzmsIrsUnB3MZuJ8ajsm8M=";
    "aarch64-linux" = "sha256-Rop4z+fSulG5JQcN8vT7gCAtmxROrTELBRFI/4KKJMw=";
  };

  # JetBrains no longer serves the standalone kotlin-server tarballs on their CDN
  # (every language-server/kotlin-server/*.tar.gz is 404, including the links in
  # the GitHub release notes), so the server is taken from the VS Code extension,
  # which ships the same tree under extension/server.
  extensionVersion = "0.0.13";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "263.6379.0"; # extension/server/build.txt

  src = fetchzip {
    url = "https://JetBrains.gallery.vsassets.io/_apis/public/gallery/publisher/JetBrains/extension/kotlin-server/${extensionVersion}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=${platform}";
    extension = "zip";
    stripRoot = false;
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
    runHook preInstall

    cd extension/server

    chmod +x ./bin/intellij-server ./jbr/bin/java

    # kotlin-lsp is headless so we can reduce the auto-patchelf dependencies
    rm ./jbr/lib/lib{awt_{wl,x}awt,jawt,fontmanager,jsound,{wl,}splashscreen}*

    # retain original directory structure to reduce necessary patching
    mkdir -p $out/opt/kotlin-lsp $out/bin
    cp -r ./* $out/opt/kotlin-lsp
    # kotlin-lsp.sh only warns that it is deprecated and execs this
    ln -s "$out/opt/kotlin-lsp/bin/intellij-server" "$out/bin/kotlin-lsp"

    runHook postInstall
  '';

  # also checks the JVM classpath and statically (i.e. at import time) loaded native libraries
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} --version";
    version = "${finalAttrs.version}-EAP";
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
