final: prev:

{
  wechat =
    if final.stdenvNoCC.hostPlatform.system == "x86_64-linux" then
      final.callPackage (prev.path + "/pkgs/by-name/we/wechat/linux.nix") {
        inherit (prev.wechat) meta version;
        pname = "wechat";
        src = final.fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-T1StKQLs1vb9xWgLc1R/gNVCO/RwsBI3pXmi5bPK7us=";
        };
      }
    else
      prev.wechat;

  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (_: rec {
    version = "1.0.4";
    src = prev.fetchFromGitHub {
      owner = "earendil-works";
      repo = "pi";
      tag = "v${version}";
      hash = "sha256-twDmQRr7vsrYzhS8o3TrlqdBzRFCbOOn/4hbCXD/u3Q=";
    };
    modelData = prev.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${version}.tgz";
      hash = "sha256-L9W/V8altbgtRWOxiiYnsU103Eqsv2mj3PkcCR5gOM8=";
    };
    npmDepsHash = "sha256-1H7z6y8czHF3Dewqqy5DA/RNeo2//J1eBYZqryX0MbU=";
    npmDeps = prev.fetchNpmDeps {
      name = "pi-coding-agent-${version}-npm-deps";
      inherit src;
      hash = npmDepsHash;
    };
  });
}
