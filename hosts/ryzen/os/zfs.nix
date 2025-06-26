{
  pkgs,
  config,
  lib,
  ...
}:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    # FIX: bluetooth
    lib.init (
      lib.init (
        lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
          builtins.attrValues zfsCompatibleKernelPackages
        )
      )
    )
  );
in
{
  boot = {
    kernelPackages = latestKernelPackage;
    supportedFilesystems = {
      zfs = true;
    };
    extraModprobeConfig = ''
      options zfs zfs_arc_max=68719476736 zfs_dirty_data_max=8589934592 l2arc_headroom=0
    '';
    zfs.extraPools = [ "ryzen" ];
  };

  networking.hostId = "2da72dea";

  services.zfs = {
    trim.enable = true;
    autoScrub = {
      enable = true;
      interval = "monthly";
      pools = [ "ryzen" ];
      randomizedDelaySec = "1h";
    };
    # zfs set com.sun:auto-snapshot:weekly=false DATASET
    autoSnapshot.enable = true;
  };
}
