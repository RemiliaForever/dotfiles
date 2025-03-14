{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1f5f6a01-ab74-453b-8be6-8ae688208811";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A712-D53C";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  fileSystems."/mnt/sdcard" = {
    device = "/dev/disk/by-uuid/e2edb8bc-f5d0-4201-b5aa-cdd0e5831054";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
    ];
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/ceb4e4ba-dcd4-4e50-bf70-f0fa2be67a52"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
