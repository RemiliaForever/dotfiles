# if [ "$FHS_CURRENT" != "$1" ]; then
#     export FHS_CURRENT=$1
#     use flake path:"$PWD/.shell"
# fi

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
          default =
            (pkgs.buildFHSEnv {
              name = "FHS";
              targetPkgs =
                pkgs:
                (with pkgs; [
                  python3
                  uv
                ]);

              profile = ''
                export SHELL=${pkgs.zsh}/bin/zsh
                export UV_PYTHON_DOWNLOADS="never"

                pushd /path/to/project
                if [ ! -d ".venv" ]; then
                    uv venv .venv
                fi
                unset PYTHONPATH
                uv sync
                source .venv/bin/activate
                popd
              '';

              runScript = "zsh";
            }).env;
        }
      );
    };
}
