{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../nixos/gui
    ../../nixos/virtualisation.nix
  ];

  # boot = { kernelParams = [ ]; };
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    #extraPackages = with pkgs; [
    #  mesa_drivers
    #  xorg.xf86videoqxl
    #];
  };
  services.xserver.videoDrivers = [ "qxl" ];

  environment.systemPackages = [
    #pkgs.xorg.xf86videoqxl
  ];
}
