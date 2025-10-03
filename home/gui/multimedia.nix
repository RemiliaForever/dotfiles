{
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    #bambu-studio # NOTE: user login notwork
    (blender.override {
      cudaSupport = config.remilia.cuda;
      hipSupport = config.remilia.rocm;
    })
    darktable
    kdePackages.kdenlive
    kdePackages.kwave
    krita
    lmms
    (obs-studio.override { cudaSupport = config.remilia.cuda; })
  ];
}
