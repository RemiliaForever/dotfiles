{ lib, ... }:

{
  systemd.coredump.settings.Coredump.Storage = "none";

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
