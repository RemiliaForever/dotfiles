{ pkgs, ... }:

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
        sansSerif = [ "Noto Sans CJK SC" ];
        emoji = [
          "Noto Color Emoji"
          "VictorMono Nerd Font"
        ];
        monospace = [
          "VictorMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];
      };
    };
  };

  xdg.menus.enable = true;
  environment.pathsToLink = [ ];

  programs.dconf.enable = true;
  services = {
    udisks2.enable = true;
    thermald.enable = false;
  };
}
