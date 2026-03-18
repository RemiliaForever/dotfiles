{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
  ];

  home.packages = with pkgs; [
    wechat
    qq
    slack

    krita # from multimedia
  ];

  # cli
  programs.starship.settings.hostname.style = "green";

  # wayland
  programs.niri = {
    autoStart = true;
  };
}
