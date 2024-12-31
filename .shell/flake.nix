{
  description = "A basic flake for nix-direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

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
            go

            bash-language-server
            gopls
            isort
            pyright
            yapf

            taplo
            sops
          ];
          shellHook = ''
            export GOPATH=$PWD/.shell/go
          '';
        };
      }
    );
}
