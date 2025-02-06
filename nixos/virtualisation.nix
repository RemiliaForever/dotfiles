{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      daemon.settings = {
        insecure-registries = [ "172.17.0.5:5050" ];
        userland-proxy = false;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  boot.binfmt = {
    preferStaticEmulators = true;
    emulatedSystems = [ "aarch64-linux" ];
  };

  users.users.remilia.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
