final: prev:

{
  # https://github.com/NixOS/nixpkgs/pull/427468
  # https://github.com/NixOS/nixpkgs/pull/438521
  bambu-studio =
    (import
      (builtins.fetchTree {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        rev = "621b44afe230ac72e9251da72d4b0e31a910b237";
      })
      {
        system = final.stdenv.system;
      }
    ).bambu-studio.overrideAttrs
      (oldAttrs: rec {
        version = "02.02.01.60";
        src = final.fetchFromGitHub {
          owner = "bambulab";
          repo = "BambuStudio";
          tag = "v${version}";
          hash = "sha256-Ttv0LwJ0GnDhmxofP7c3CJMawad8AhAToZFOvoK3Zow=";
        };
      });
}
