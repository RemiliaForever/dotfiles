{
  pkgs,
  cudaSupport ? false,
  rocmSupport ? false,
  ...
}:

{
  home.packages = with pkgs; [
    #bambu-studio # NOTE: user login notwork
    (blender.override {
      inherit cudaSupport rocmSupport;
    })
    darktable
    kdePackages.kdenlive
    kdePackages.kwave
    krita
    ardour
    (obs-studio.override { inherit cudaSupport; })
  ];
}
