{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    amdgpu_top
    lact
  ];

  hardware = {
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
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lact.enable = true;
}
