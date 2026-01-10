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

  # https://github.com/NixOS/nixpkgs/pull/478345
  qq = prev.qq.overrideAttrs (oldAttrs: {
    version = "3.2.23-2026-01-08";
    src = final.fetchurl {
      url = "https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.23_260108_amd64_01.deb";
      hash = "sha256-pCUnGcG+uK3ODaCev8MQzlDHnqVI9czkKVBXZdC/uoQ=";
    };
  });
}
