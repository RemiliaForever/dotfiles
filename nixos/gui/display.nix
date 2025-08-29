{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "us";
    displayManager.startx.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # font
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      symbola
      nerd-fonts.fantasque-sans-mono
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
          "FantasqueSansM Nerd Font Mono"
          "Noto Sans Mono CJK SC"
          "Symbola"
        ];
      };
    };
  };
}
