# if [ "$FHS_CURRENT" != "$1" ]; then
#     export FHS_CURRENT=$1
#     use flake path:"$PWD/.shell"
# fi

{
  description = "A basic flake for nix-direnv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default =
          (pkgs.buildFHSEnv {
            name = "FHS";
            targetPkgs =
              pkgs:
              (with pkgs; [
                glib
                libz
                libssh2
                libgcrypt
                libGL
                libpng
                harfbuzz
                libgcrypt
                libsForQt5.qt5.qtbase
                libsForQt5.qt5.qtdeclarative
                libsForQt5.qt5.qtwebsockets
                libsForQt5.qt5.qtquickcontrols
                libsForQt5.qt5.qtquickcontrols2
              ]);
          }).env;
      }
    );
}
