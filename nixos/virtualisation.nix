{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      daemon.settings = {
        registry-mirrors = [ "http://172.17.0.5:5000" ];
        insecure-registries = [ "172.17.0.5:5050" ];
        userland-proxy = false;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.remilia.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
