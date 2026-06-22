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
          default = pkgs.mkShell rec {
            packages = with pkgs; [
              python3
              uv
            ];

            ROOT_DIR = "/path/to/your/project";
            PATH = "$ROOT_DIR/.venv/bin:$PATH";
            UV_PYTHON_DOWNLOADS = "never";
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath packages;

            shellHook = ''
              pushd $ROOT_DIR
              if [ ! -d ".venv" ]; then
                  uv venv .venv
              fi
              unset PYTHONPATH
              uv sync
              source .venv/bin/activate
              popd
            '';
          };
        }
      );
    };
}
