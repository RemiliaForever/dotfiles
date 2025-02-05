{ pkgs, ... }:

let
  ddns = pkgs.buildGoModule {
    name = "ddns";
    src = ./ddns;
    vendorHash = "sha256-fdXoyKmY+RwMFMQU2KlF3cc28sZV7E+ab+QMcG1NMqc=";
  };
in
{
  systemd = {
    timers = {
      ddns = {
        description = "Update dgsh dns record";
        wantedBy = [ "timers.target" ];
        after = [ "multi-user.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "1h";
        };
      };
    };
    services = {
      ddns = {
        description = "Update dgsh dns record";
        restartIfChanged = false;
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
        };
        script = "${ddns}/bin/ddns";
      };
    };
  };
}
