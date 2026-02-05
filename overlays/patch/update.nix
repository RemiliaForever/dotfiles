final: prev:

{
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (oldAttrs: rec {
    version = "0.0.396";
    src = final.fetchzip {
      url = "https://registry.npmjs.org/@github/copilot/-/copilot-${version}.tgz";
      hash = "sha256-jlGD4PoZi4eIeE5q94Gmw9Z/Sk5SJPbZrg50OtNyavQ=";
    };
    nativeInstallCheckInputs = [ ];
  });

  qq = prev.qq.overrideAttrs (oldAttrs: {
    version = "3.2.25-2026-02-05";
    src = final.fetchurl {
      url = "https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.25_260205_amd64_01.deb";
      hash = "sha256-TVEHWd8lyfhcfj6E83XDaFq2L75wtNNI97osG6iCvuA=";
    };
  });
}
