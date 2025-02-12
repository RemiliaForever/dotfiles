final: prev:

{
  #380267
  feishu = prev.feishu.overrideAttrs (old: {
    installPhase = ''
      ${old.installPhase}
      rm $out/opt/bytedance/feishu/libcurl.so
    '';
  });
}
