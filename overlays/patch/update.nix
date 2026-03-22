final: prev:

{
  qq = prev.qq.overrideAttrs (oldAttrs: {
    version = "3.2.25-2026-02-05";
    src = final.fetchurl {
      url = "https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.25_260205_amd64_01.deb";
      hash = "sha256-TVEHWd8lyfhcfj6E83XDaFq2L75wtNNI97osG6iCvuA=";
    };
  });

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (oldAttrs: rec {
    version = "0.8.1";
    src = final.fetchFromGitHub {
      owner = "Supreeeme";
      repo = "xwayland-satellite";
      tag = "v${version}";
      hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
    };
  });

  wiliwili = prev.wiliwili.overrideAttrs (oldAttrs: {
    version = "aa1f157";
    src = final.fetchFromGitHub {
      owner = "xfangfang";
      repo = "wiliwili";
      rev = "aa1f157540c2c1b824605cdbdfb78cb072ffb6bd";
      fetchSubmodules = true;
      hash = "sha256-TOTo3Oyf2vWqOz/Jn1+o7I0ym8DM6+lzy/jDq1uAnFw=";
    };
  });
}
