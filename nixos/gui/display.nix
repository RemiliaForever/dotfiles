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
      victor-mono

      nerd-fonts.symbols-only
      twemoji-color-font
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        emoji = [
          "Twitter Color Emoji"
        ];
        monospace = [
          "Victor Mono"
          "Noto Sans Mono CJK SC"
          "Symbols Nerd Font Mono"
        ];
      };
    };
  };
}
