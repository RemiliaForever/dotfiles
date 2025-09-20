{ host, ... }:

{
  imports = [
    ./singbox.nix
    ./zerotier.nix
  ];
  networking = {
    hostName = "koumakan-${host.hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nftables.enable = true;
  };

  users.users.remilia.extraGroups = [ "networkmanager" ];

  programs.ssh.extraConfig = ''
    Host dmit
        HostName koumakan.cc
        Port 121
        User root
  '';
}
