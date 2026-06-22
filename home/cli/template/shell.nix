# use flake path:"$PWD/.shell"

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
          default = pkgs.mkShell {
            packages = with pkgs; [
              pv
            ];

            # NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
            # NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [];

            shellHook = "";
          };
        }
      );
    };
}
