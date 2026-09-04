{ lib, ... }:

{
  systemd = {
    coredump.settings.Coredump.Storage = "none";

    tmpfiles.rules = [ "q /tmp 1777 root root 2h" ];

    timers.systemd-tmpfiles-clean.timerConfig = {
      OnBootSec = "15min";
      OnUnitActiveSec = "1h";
    };
  };

  services = {
    openssh.enable = true;
    fstrim.enable = true;

    speechd.enable = lib.mkForce false;

    logind.settings.Login = {
      HandlePowerKey = lib.mkDefault "suspend";
      HandlePowerKeyLongPress = lib.mkDefault "ignore";
      HandleLidSwitch = lib.mkDefault "ignore";
      HandleLidSwitchDocked = lib.mkDefault "ignore";
      HandleLidSwitchExternalPower = lib.mkDefault "ignore";
    };

    journald = {
      extraConfig = ''
        SystemMaxUse=1G
        RuntimeMaxUse=512M
      '';
    };
  };
}
