{ ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nixpkgs-update.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
      ];
      trusted-users = [
        "remilia"
        "root"
      ];
      auto-optimise-store = true;

      download-buffer-size = 268435456;
    };

    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };

    #gc = {
    #  automatic = true;
    #  dates = "weekly";
    #  delete_generations = "+3";
    #};
  };

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "daily";
    clean.extraArgs = "--keep 5 --keep-since 1w";
  };
}
