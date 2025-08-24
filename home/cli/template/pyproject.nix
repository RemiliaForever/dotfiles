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
        project = pyproject-nix.lib.project.loadPyproject { projectRoot = ./.; };
        python = pkgs.python3;
      in
      {
        devShells.default =
          let
            arg = project.renderers.withPackages { inherit python; };
            pythonEnv = python.withPackages arg;
          in
          pkgs.mkShell {
            packages = [ pythonEnv ];
          };
      }
    );
}
