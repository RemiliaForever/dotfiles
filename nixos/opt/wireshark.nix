{ pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.remilia.extraGroups = [
    "wireshark"
  ];
}
