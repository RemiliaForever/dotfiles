{ ... }:

{
  systemd.coredump.extraConfig = "Storage=none";

  services = {
    openssh.enable = true;
    fstrim.enable = true;

    speechd.enable = false;

    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "ignore";
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };

    journald = {
      extraConfig = ''
        SystemMaxUse=1G
        RuntimeMaxUse=512M
      '';
    };
  };
}
