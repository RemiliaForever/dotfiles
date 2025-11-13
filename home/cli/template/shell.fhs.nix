# if [ "$FHS_CURRENT" != "$1" ]; then
#     export FHS_CURRENT=$1
#     use flake path:"$PWD/.shell"
# fi

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
          };
        in
        {
          default =
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
    };
}
