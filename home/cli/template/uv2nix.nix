{
  description = "uv2nix devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        python = pkgs.python313;
        cudaPatch = old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [ ])
            ++ (with pkgs; [
              autoAddDriverRunpath
              cudaPackages.cuda_nvcc
            ]);
          buildInputs =
            (old.buildInputs or [ ])
            ++ (with pkgs.cudaPackages; [
              cuda_cccl
              cuda_cudart
              cuda_cupti
              cuda_nvcc
              cuda_nvml_dev
              cuda_nvrtc
              cuda_nvtx
              cudnn
              libcublas
              libcufft
              libcurand
              libcusolver
              libcusparse
              nccl
            ]);
        };
        pyprojectOverrides = final: prev: {
          english-words = prev.english-words.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ final.resolveBuildSystem { setuptools = [ ]; };
          });
          html2text = prev.html2text.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ final.resolveBuildSystem { setuptools = [ ]; };
          });

          # cuda support
          torch = prev.torch.overrideAttrs cudaPatch;
          nvidia-cusolver-cu12 = prev.nvidia-cusolver-cu12.overrideAttrs cudaPatch;
          nvidia-cusparse-cu12 = prev.nvidia-cusparse-cu12.overrideAttrs cudaPatch;
        };

        workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
        pythonSet =
          (pkgs.callPackage inputs.pyproject-nix.build.packages {
            inherit python;
          }).overrideScope
            (
              pkgs.lib.composeManyExtensions [
                inputs.pyproject-build-systems.overlays.default
                (workspace.mkPyprojectOverlay {
                  sourcePreference = "wheel";
                })
                pyprojectOverrides
              ]
            );
        venv = pythonSet.mkVirtualEnv "venv" workspace.deps.default;
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              venv
              playwright-driver.browsers
            ];
            env = {
              PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
              PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
            };
          };
          uv = pkgs.mkShell {
            packages = with pkgs; [
              python
              uv
            ];
            env = {
              UV_PYTHON = python.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
              UV_NO_SYNC = "1";
            };
          };
        };
      }
    );
}
