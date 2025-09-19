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
    # deluge
    baidupcs-go

    lark
    qq
    wechat
    discord
    telegram-desktop
  ];

  remilia = {
    cuda = true;
  };

  # cli
  programs.starship.settings.hostname.style = "yellow";
  programs.zsh.initContent = ''
    # sync
    sb() {
        cmd="rsync -v -aP --mkpath --delete $PWD/$1/ ''${S_HOST:-win}:''${PWD#/home/remilia/}/$1/ --exclude .git --exclude .cache --exclude .direnv ''${@:2}"
        echo "$cmd"
        eval "$cmd"
    }
    s() {
        sb "$1" --exclude build
    }
  '';

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
        "[workspace 3 silent] sleep 3 && firefox"

        "[workspace 4 silent] sleep 5 && wechat"
        "[workspace 4 silent] sleep 5 && qq"
        "[workspace 4 silent] sleep 5 && bytedance-lark"
        "[workspace 4 silent] sleep 5 && discord"
        "[workspace 4 silent] sleep 5 && Telegram"

        "[workspace 5 silent] sleep 8 && spotify"
        "[workspace 5 silent] sleep 8 && steam"

        "sleep 5 && pkill hypridle"
      ];
    };
  };
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [ "/sys/devices/pci0000:00/0000:00:18.3/hwmon" ];
    input-filename = "temp1_input";
  };
}
