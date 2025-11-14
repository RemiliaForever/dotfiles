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
              uv
            ];

            buildInputs = [ ];

            nativeBuildInputs = [ ];

            env = {
              UV_PYTHON = pkgs.python3.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
            };
            shellHook = ''
              if [ ! -d ".venv" ]; then
                uv venv .venv
              fi
              unset PYTHONPATH
              uv sync
              source .venv/bin/activate
            '';
          };
        }
      );
    };
}
