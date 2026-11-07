final: prev:

{
  adwsteamgtk = prev.adwsteamgtk.overrideAttrs (_: {
    version = "0.9.1";
    src = prev.fetchFromGitHub {
      owner = "Foldex";
      repo = "AdwSteamGtk";
      tag = "v0.9.1";
      hash = "sha256-ICDagK/vklptnn9NjVMNLkflfwKxlyeWfMqp/pvZLTE=";
    };
  });

  # wechat =
  #   if final.stdenvNoCC.hostPlatform.system == "x86_64-linux" then
  #     final.callPackage (prev.path + "/pkgs/by-name/we/wechat/linux.nix") {
  #       inherit (prev.wechat) meta version;
  #       pname = "wechat";
  #       src = final.fetchurl {
  #         url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
  #         hash = "sha256-T1StKQLs1vb9xWgLc1R/gNVCO/RwsBI3pXmi5bPK7us=";
  #       };
  #     }
  #   else
  #     prev.wechat;
}
