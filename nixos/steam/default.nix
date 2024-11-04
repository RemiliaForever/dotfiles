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
    };
  };
  environment.systemPackages = with pkgs; [ mangohud ];
}
