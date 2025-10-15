{
  pkgs,
  cudaSupport ? false,
  hipSupport ? false,
  ...
}:

{
  home.packages = with pkgs; [
    #bambu-studio # NOTE: user login notwork
    (blender.override {
      inherit cudaSupport hipSupport;
    })
    darktable
    kdePackages.kdenlive
    kdePackages.kwave
    krita
    lmms
    (obs-studio.override { inherit cudaSupport; })
  ];
}
