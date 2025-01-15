{ pkgs, lib, ... }:

{

  imports = [
    ./display.nix
    ./audio.nix
    ./bluetooth.nix
    ./input_method.nix
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

  xdg.menus.enable = true;
  environment.pathsToLink = [
    #"/share/xdg-desktop-portal"
  ];

  programs.dconf.enable = true;
  services = {
    udisks2.enable = true;
    thermald.enable = false;
  };
}
