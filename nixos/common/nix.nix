{ ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      max-substitution-jobs = 32;
      http-connections = 32;
      download-buffer-size = 268435456;
      substituters = [
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "remilia"
        "root"
      ];

      auto-optimise-store = true;
    };

    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "daily";
    clean.extraArgs = "--keep 5 --keep-since 1w";
  };

  programs.nix-ld.enable = true;
  services.envfs.enable = true;
}
