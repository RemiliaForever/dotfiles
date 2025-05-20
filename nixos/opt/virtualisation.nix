{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      daemon.settings = {
        bip = "172.19.0.1/16";
        insecure-registries = [ "172.18.10.1:5050" ];
        live-restore = false;
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
