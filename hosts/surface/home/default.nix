{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
  ];

  home.packages = with pkgs; [
    lark
    wechat-uos
    qq
    discord

    krita # from multimedia
  ];

  # cli
  programs.starship.settings.hostname.style = "green";

  # wayland
  programs.zsh.loginExtra = ''
    # UWSM
    if [[ -z "$SSH_CLIENT" ]] && uwsm check may-start -q && uwsm select; then
        exec uwsm start default
    fi
  '';
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/platform/coretemp.0/hwmon" ];
    input-filename = "temp1_input";
  };
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
}
