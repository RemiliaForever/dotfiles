final: prev:

{
  # upgrade to latest version
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (oldAttrs: rec {
    version = "0.0.396";
    src = final.fetchzip {
      url = "https://registry.npmjs.org/@github/copilot/-/copilot-${version}.tgz";
      hash = "sha256-jlGD4PoZi4eIeE5q94Gmw9Z/Sk5SJPbZrg50OtNyavQ=";
    };
    nativeInstallCheckInputs = [ ];
  });

  # apply patch to niri
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

  # https://github.com/NixOS/nixpkgs/pull/478345
  qq = prev.qq.overrideAttrs (oldAttrs: {
    version = "3.2.25-2026-02-05";
    src = final.fetchurl {
      url = "https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.25_260205_amd64_01.deb";
      hash = "sha256-TVEHWd8lyfhcfj6E83XDaFq2L75wtNNI97osG6iCvuA=";
    };
  });
}
