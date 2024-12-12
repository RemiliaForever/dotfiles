{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;

    docker.enable = true;
  };
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.remilia.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
