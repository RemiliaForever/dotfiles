{ ... }:

{
  imports = [
    ./display.nix
    ./audio.nix
    ./bluetooth.nix
    # ./input_method.nix
    ./printing.nix
  ];

  programs.dconf.enable = true;
  services = {
    udisks2.enable = true;
    thermald.enable = false;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # portals and keyring
  security.pam.services.login.enableGnomeKeyring = true;
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
}
