{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freerdp3
    #kicad
    #openscad
    texliveFull
  ];
}
