final: prev:

let
  override = {
    extraPkgs = pkgs: [ pkgs.bubblewrap ];
  };

in
{
  honkers-launcher = prev.honkers-launcher.override override;
  anime-game-launcher = prev.anime-game-launcher.override override;
  honkers-railway-launcher = prev.honkers-railway-launcher.override override;
  sleepy-launcher = prev.sleepy-launcher.override override;
}
