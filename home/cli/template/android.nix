# use flake path:$PWD/.shell

{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    {
      devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (

        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.android_sdk.accept_license = true;
          };
          # android sdk setup
          buildToolsVersion = "35.0.0";
          androidComposition = pkgs.androidenv.composeAndroidPackages {
            buildToolsVersions = [ buildToolsVersion ];
            platformVersions = [ "35" ];
            includeNDK = true;
            includeCmake = true;
            cmakeVersions = [ "3.22.1" ];
          };

        in
        {
          devShells.default = pkgs.mkShell rec {
            nativeBuildInputs = with pkgs; [
              (writeShellScriptBin "gradle" ''${pkgs.gradle}/bin/gradle $GRADLE_OPTS "$@"'')
              androidComposition.androidsdk
              (androidenv.emulateApp {
                name = "emulate-MyAndroidApp";
                platformVersion = "31";
                abiVersion = "x86_64";
                systemImageType = "default";
              })
            ];

            ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
            ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";

            shellHook = '''';
          };
        }
      );
    };
}
