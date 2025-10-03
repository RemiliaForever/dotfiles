final: prev:

{
  hyprlandPlugins = prev.hyprlandPlugins // {

    # https://github.com/NixOS/nixpkgs/issues/443989
    hyprspace = prev.hyprlandPlugins.hyprspace.overrideAttrs (old: {
      version = "0-unstable-2025-09-28";
      src = final.fetchFromGitHub {
        owner = "KZDKM";
        repo = "hyprspace";
        rev = "e54884da1d6a1af76af9d053887bf3750dd554fd";
        hash = "sha256-QhcOFLJYC9CiSVPkci62ghMEAJChzl+L98To1pKvnRQ=";
      };
    });

    # https://github.com/NixOS/nixpkgs/pull/448008
    hyprsplit = prev.hyprlandPlugins.hyprsplit.overrideAttrs (old: rec {
      version = "0.51.1";
      src = final.fetchFromGitHub {
        owner = "shezdy";
        repo = "hyprsplit";
        tag = "v${version}";
        hash = "sha256-7cnfq7fXgJHkmHyvRwx8UsUdUwUEN4A1vUGgsSb4SmI=";
      };
    });
  };
}
