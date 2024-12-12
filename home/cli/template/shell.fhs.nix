{
  description = "nix flake shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default =
          (pkgs.buildFHSEnv {
            name = "FHS Env";
            targetPkgs =
              pkgs:
              (with pkgs; [
                glibc
                libz
                libgcrypt
                libssh2
                libGL
                libpng16
                libharfbuzz
              ]);
            runScript = "bash";
          }).env;
      }
    );
}
