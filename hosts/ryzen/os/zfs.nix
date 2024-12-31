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
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
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
      options zfs zfs_arc_max=103079215104 zfs_dirty_data_max=8589934592
    '';
    zfs.extraPools = [ "ryzen" ];
  };

  networking.hostId = "2da72dea";

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
      pools = [ "ryzen" ];
      randomizedDelaySec = "1h";
    };
    # zfs set com.sun:auto-snapshot:weekly=false DATASET
    autoSnapshot.enable = true;
  };

  systemd = {
    timers = {
      zfs_download_snapshot = {
        description = "Download snapshot from server";
        wantedBy = [ "timers.target" ];
        after = [ "multi-user.target" ];
        timerConfig = {
          OnCalendar = "Sun 02:30";
          Persistent = true;
        };
      };
    };
    services = {
      zfs_download_snapshot = {
        description = "Download snapshot from server";
        restartIfChanged = false;
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
        };
        script = builtins.readFile ./zfs_download_snapshot.sh;
      };
    };
  };
}
