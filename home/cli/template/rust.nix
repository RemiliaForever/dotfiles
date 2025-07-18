# use flake path:"$PWD/.shell"

{
  description = "nix flake shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (rust-bin.beta.latest.default.override {
              extensions = [ "rust-analyzer" ];
            })
          ];

          shellHook = '''';
        };
      }
    );
}
