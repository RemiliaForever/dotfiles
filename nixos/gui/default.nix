{ pkgs, lib, ... }:

{

  imports = [
    ./display.nix
    ./audio.nix
    ./bluetooth.nix
    ./fcitx5.nix
  ];

  # font
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.victor-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans Serif CJK SC" ];
        emoji = [
          "VictorMono Nerd Font"
          "Noto Color Emoji"
        ];
        monospace = [
          "VictorMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];
      };
    };
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DOWNLOAD=Downloads
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  services = {
    udisks2.enable = true;
    thermald.enable = false;
  };
}
