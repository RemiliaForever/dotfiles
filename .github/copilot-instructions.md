# Copilot Instructions for This Repository

## High-Level Architecture

- **Nix Flake-based NixOS configuration**
  - `flake.nix` defines all system and home-manager configurations using multiple inputs (nixpkgs, home-manager, sops-nix, overlays, etc.).
  - `hosts/` contains per-host directories, each with `hostname.nix`, `os`, and `home` for system and user configuration.
  - `nixos/` contains modular NixOS configuration files (e.g., `common`, `gui`, `opt`).
  - `home/` contains modular Home Manager configuration files for user environments.
  - `overlays/` provides custom Nixpkgs overlays for additional packages or modifications.
  - `build/` is used for build outputs per host.

## Key Conventions

- **Host-based configuration:** Each host in `hosts/` has its own system (`os`) and user (`home`) configuration, imported by `flake.nix`.
- **Modularization:** Both NixOS and Home Manager configs are split into logical modules for reusability.
- **Username:** The primary user is `remilia` with home directory `/home/remilia`.
- **Secrets:** Secrets are managed via `sops-nix` and imported in relevant modules.
- **Overlays:** Custom overlays are defined in `overlays/` and referenced in `flake.nix`.
- **No traditional test suite:** System validation is performed by activating/switching NixOS configurations.

## Git Commit Message Convention

- Format: `[module][submodule] change summary`
  - Examples:
    - `[home][cli] add mutt alias`
    - `[nixos][opt] add proton-ge to steam`
    - `[overlays][app] update lark`
- Notes:
  - Use `[]` for top-level and subdirectory or feature module, matching the actual directory structure when possible
  - The summary should be a concise description in English
  - English is recommended for all commit messages
