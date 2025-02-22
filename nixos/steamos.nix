{
  jovian,
  config,
  lib,
  ...
}:

{

  imports = [
    jovian.nixosModules.jovian
  ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  jovian = {
    decky-loader = {
      user = "remilia";
    };
    steam = {
      desktopSession = "hyprland-uwsm";
      user = "remilia";
    };
  };

  # fix gamescope-session steam cjk fonts
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
