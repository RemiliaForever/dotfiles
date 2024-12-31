{ ... }:

{
  services = {
    openssh.enable = true;
    fstrim.enable = true;

    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "ignore";
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };

    speechd.enable = false;
  };
}
