{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  name = "digikam-wrapper";
  buildInputs = [
    pkgs.digikam
    pkgs.mariadb
  ];
  src = null;
  unpackPhase = "true";
  shellHook = ''
    export PATH=${pkgs.mariadb}/bin:$PATH
  '';
}
