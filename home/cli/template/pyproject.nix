# use flake path:"$PWD/.shell"

{
  description = "uv2nix devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      pyproject-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pythonEnv =
          pkgs.python3.withPackages
            (pyproject-nix.lib.project.loadPyproject { projectRoot = ./.; }).renderers.withPackages
            { python = pkgs.python3; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ pythonEnv ];
        };
      }
    );
}
