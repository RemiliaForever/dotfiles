final: prev:

{
  niri = prev.niri.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches or [ ]
      ++
        # https://github.com/YaLTeR/niri/pull/2609
        [
          ./niri/0001-add-feat-force-render.patch
          ./niri/0002-Unify-force-render-logic-and-ensure-each-window-uses.patch
        ]
      ++ [
        # https://github.com/YaLTeR/niri/pull/1791
        (final.fetchpatch {
          url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing_2~19..tag_support-shm-sharing_2.patch";
          hash = "sha256-M2Z2HMwuJpDtk7bvvREXF21cHVra+qqUUeaKCywLt48=";
        })
      ];
  });
}
