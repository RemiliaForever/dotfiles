{
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    bambu-studio
    (blender.override {
      cudaSupport = config.remilia.cuda;
      hipSupport = config.remilia.rocm;
    })
    darktable
    kdePackages.elisa
    kdePackages.kdenlive
    kdePackages.kwave
    krita
    #lmms
    (obs-studio.override { cudaSupport = config.remilia.cuda; })
  ];
}
