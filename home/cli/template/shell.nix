# use flake path:$PWD/.shell

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
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            taplo

            go
            gopls

            cargo
            clippy
            rust-analyzer
            rustc
            rustfmt
          ];

          shellHook = ''
            GOPATH=$PWD/.shell/go
            CARGO_HOME=$PWD/.shell/cargo
          '';
        };
      }
    );
}
