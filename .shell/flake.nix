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
          name = "dotfiles";
          packages = with pkgs; [
            go

            lua-language-server
            bash-language-server
            nixd
            gopls
            pyright

            sops
          ];
          shellHook = ''
            export GOPATH=$PWD/.shell/go
          '';
        };
      }
    );
}
