{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "2.0.0";

  # we can safely reason about what version it is.
  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/truetype"

    cp $src/Berkeley-Mono-Variable.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Berkeley Mono Typeface";
    homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
