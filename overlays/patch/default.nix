final: prev:

{
  #383402
  obs-studio = prev.obs-studio.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.autoAddDriverRunpath ];
  });
}
