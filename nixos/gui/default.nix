{ pkgs, lib, ... }:

{

  imports = [
    ./display.nix
    ./audio.nix
  ];

  # inputMethod
  i18n.inputMethod = {
    enabled = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-chinese-addons
        fcitx5-material-color
      ];
      settings = {
        inputMethod = { };
      };
    };
  };

  # font
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      victor-mono
      (nerdfonts.override { fonts = [ "VictorMono" ]; })
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
    DESKTOP=Desktop
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

  services.udisks2.enable = true;
}
