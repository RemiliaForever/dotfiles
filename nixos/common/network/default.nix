{ hostname, ... }:

{
  imports = [
    ./singbox.nix
    ./zerotier.nix
  ];
  networking = {
    hostName = "koumakan-${hostname.hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nftables.enable = true;
  };

  programs.ssh.extraConfig = ''
    Host dmit
        HostName koumakan.cc
        Port 121
        User root
  '';

  users.users.remilia.extraGroups = [ "networkmanager" ];
}
