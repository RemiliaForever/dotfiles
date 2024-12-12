{ hostname, ... }:

{
  networking = {
    hostName = "koumakan-${hostname.hostname}";

    networkmanager = {
      enable = true;
    };
  };

  users.users.remilia.extraGroups = [ "networkmanager" ];
}
