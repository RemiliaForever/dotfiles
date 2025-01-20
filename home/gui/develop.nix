{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freerdp3
    #kicad
    #openscad
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium
        ctex
        fontawesome5
        moderncv
        ;
    })
  ];
}
