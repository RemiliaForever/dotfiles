{ pkgs, ... }:

{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extest.enable = true;
      extraPackages = with pkgs; [ gamemode ];
      #fontPackages = with pkgs; [
      #  noto-fonts
      #  noto-fonts-cjk-sans
      #  noto-fonts-cjk-serif
      #  noto-fonts-color-emoji
      #];
    };
  };
  environment.systemPackages = with pkgs; [ mangohud ];
}
