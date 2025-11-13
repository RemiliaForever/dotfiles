# use flake path:"$PWD/.shell"

{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    {
      devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
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
    };
}
