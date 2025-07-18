# use flake path:"$PWD/.shell"

{
  description = "nix flake shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            tree-sitter
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-medium
                ctex
                fontawesome5
                moderncv
                pgf-umlsd
                xargs
                standalone
                ;
            })
          ];

          shellHook = '''';
        };
      }
    );
}
