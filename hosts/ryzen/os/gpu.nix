{ pkgs, ... }:

{
  # nvidia
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
    amdgpu = {
      opencl.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ ];
    };
  };
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];
}
