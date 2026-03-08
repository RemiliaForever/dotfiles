{
  jovian,
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    jovian.nixosModules.jovian
  ];

  environment.systemPackages = with pkgs; [
    adwsteamgtk
  ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  jovian = {
    decky-loader = {
      user = "remilia";
    };
    steam = {
      desktopSession = "niri";
      user = "remilia";
    };
  };

  # https://github.com/Jovian-Experiments/Jovian-NixOS/pull/376
  nixpkgs.overlays = [
    (final: prev: {
      gamescope-session = prev.gamescope-session.override {
        steam = prev.steam.override (old: {
          extraPkgs =
            pkgs: config.programs.steam.extraPackages ++ lib.optionals (old ? extraPkgs) (pkgs: [ pkgs ]);
        });
      };
    })
  ];
}
