{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.extraConfig."51-edifier-no-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "~alsa_output.usb-Jieli_Technology_EDIFIER_Halo_Soundbar_Max.*";
            }
          ];
          actions = {
            "update-props" = {
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [ pulsemixer ];
}
