{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "nct6687"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/18e69ff2-d1fc-4bdb-8dde-3830580e21cc";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/33FA-387F";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  fileSystems."/mnt/zhitai" = {
    device = "/dev/disk/by-uuid/ee61a06f-df2e-40e5-91c4-74e3fb9ccdb2";
    fsType = "ext4";
    options = [
      "noatime"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
