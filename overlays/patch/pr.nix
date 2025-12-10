final: prev:

{
  # apply patch to niri
  niri = prev.niri.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches or [ ]
      ++
      # https://github.com/YaLTeR/niri/pull/2609
      [
        ./niri/0001-add-feat-force-render.patch
        ./niri/0002-Unify-force-render-logic-and-ensure-each-window-uses.patch
      ];
  });
}
