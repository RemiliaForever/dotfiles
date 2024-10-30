{ hostname, ... }:

{
  networking = {
    hostName = "koumakan-${hostname.hostname}";

    hosts = {
      "0.0.0.0" = [
        "log-upload.mihoyo.com"
        "ys-log-upload.mihoyo.com"
        "uspider.yuanshen.com"
        "dispatchcnglobal.yuanshen.com"
      ];
    };

    networkmanager = { enable = true; };
  };
}
