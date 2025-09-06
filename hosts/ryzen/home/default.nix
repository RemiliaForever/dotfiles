{ pkgs, ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
    ../../../home/gui/develop.nix
    ../../../home/gui/multimedia.nix
  ];

  home.packages = with pkgs; [
    deluge
    baidupcs-go

    lark
    wechat-uos
    qq
    discord
  ];

  remilia = {
    cuda = true;
  };

  # cli
  programs.starship.settings.hostname.style = "yellow";
  programs.zsh.shellAliases = {
    sb = ''rsync -aP --mkpath --delete "$PWD/" "win:''${PWD#/home/remilia/}/" --exclude ".git" --exclude ".cache" --exclude ".direnv"'';
    s = ''sb --exclude "build"'';
  };

  # wayland
  programs.zsh.loginExtra = ''
    # UWSM
    if [[ -z "$SSH_CLIENT" ]] && uwsm check may-start -q && uwsm select; then
        exec uwsm start default
    fi
  '';
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-1, highrr, 0x0, 2, vrr, 1"
      ];

      exec-once = [
        "[workspace 3 silent] sleep 5 && firefox"
        "[workspace 4 silent] sleep 5 && wechat-uos"
        "[workspace 4 silent] sleep 5 && qq"
        "[workspace 4 silent] sleep 5 && bytedance-lark"
        "[workspace 5 silent] sleep 5 && spotify"
        "[workspace 5 silent] sleep 5 && steam"

        "sleep 5 && pkill hypridle"
      ];
    };
  };
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
    input-filename = "temp1_input";
  };

  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
}
