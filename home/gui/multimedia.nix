{
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    audacity
    bambu-studio
    (blender.override {
      cudaSupport = config.remilia.cuda;
      hipSupport = config.remilia.rocm;
    })
    darktable
    #(digikam.override { enableCuda = config.remilia.cuda; })
    kdenlive
    krita
    #lmms
    pitivi
  ];
}
