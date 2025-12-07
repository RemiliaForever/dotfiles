{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "us";
    displayManager.startx.enable = true;
  };

  # font
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      symbola
      berkeley-mono
      nerd-fonts.victor-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        emoji = [
          "Symbola"
        ];
        monospace = [
          "Berkeley Mono Variable"
          "VictorMono Nerd Font"
          "Noto Sans Mono CJK SC"
          "Symbola"
        ];
      };
    };
  };
}
