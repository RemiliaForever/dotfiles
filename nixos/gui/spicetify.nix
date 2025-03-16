{ pkgs, spicetify, ... }:

let
  spicePkgs = spicetify.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ spicetify.nixosModules.spicetify ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      copyToClipboard
      betterGenres
      beautifulLyrics
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
