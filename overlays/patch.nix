final: prev:

{
  #380267
  feishu = prev.feishu.overrideAttrs (old: {
    installPhase = ''
      ${old.installPhase}
      rm $out/opt/bytedance/feishu/libcurl.so
    '';
  });

  #380533
  hyprlandPlugins = prev.hyprlandPlugins // {
    hyprspace = prev.hyprlandPlugins.hyprspace.overrideAttrs (old: {
      version = "0-unstable-2025-02-08";
      src = final.fetchFromGitHub {
        owner = "KZDKM";
        repo = "hyprspace";
        rev = "ac55bbdb6cee760af9315899b5b187a40ce43e46";
        hash = "sha256-t/KaeHEgzh225HUdAiHXRsgDeyDrBCMTg0LjR73v3Nw=";
      };
      meta = {
        broken = false;
      };
    });
  };
}
