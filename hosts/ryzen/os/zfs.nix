{ ... }:

{
  boot = {
    supportedFilesystems = {
      zfs = true;
    };
    extraModprobeConfig = ''
      options zfs zfs_arc_max=68719476736 zfs_dirty_data_max=8589934592 l2arc_headroom=0
    '';
    zfs = {
      forceImportRoot = false;
      extraPools = [ "ryzen" ];
    };
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
