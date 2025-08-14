{ aagl, ... }:

{
  imports = [ aagl.nixosModules.default ];

  nix.settings = aagl.nixConfig;

  # aaglx
  programs = {
    honkers-launcher.enable = true;
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    sleepy-launcher.enable = true;
  };
}
