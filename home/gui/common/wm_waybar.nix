{ pkgs, ... }:

let
  waybar-email-daemon = pkgs.writers.writePython3Bin "waybar-email-daemon" { } ''
    import base64
    import imaplib
    from pathlib import Path
    import re
    import signal
    import subprocess
    import sys
    import threading

    event = threading.Event()


    def imaputf7encode(s):
        s = s.replace('&', '&-')
        unipart = out = ""
        for c in s:
            if 0x20 <= ord(c) <= 0x7f:
                if unipart != "":
                    out += '&' + base64.b64encode(unipart.encode(
                        'utf-16-be')).decode('ascii').rstrip('=') + '-'
                    unipart = ""
                out += c
            else:
                unipart += c
        if unipart != "":
            out += '&' + base64.b64encode(
                unipart.encode('utf-16-be')).decode('ascii').rstrip('=') + '-'
        return out


    def update(n: int):
        if n == -255:
            res = '!!!'  # error
        elif n == -1:
            res = '󱋈 ?'  # loading
        elif n == 0:
            res = '󰇰 0'  # empty
        else:
            res = f'󰇮 {n}'  # new
        print(res)
        sys.stdout.flush()


    def fetch_mail():
        update(-1)

        name = sys.argv[1]
        server = sys.argv[2]

        username = open(
            f'{Path.home()}/.config/sops-nix/secrets/mail/{name}/address').read()
        password = open(
            f'{Path.home()}/.config/sops-nix/secrets/mail/{name}/password').read()

        try:
            M = imaplib.IMAP4_SSL(server)
            M.login(username, password)
            M.select(readonly=True)

            mails = {}
            count = 0

            for box in sys.argv[3:]:
                s = M.status(imaputf7encode(box), '(UNSEEN)')
                n = int(re.search(r'UNSEEN\s+(\d+)',
                                  str(s)).group(1))  # type: ignore
                mails[box] = n
                count += n

            update(count)
            if count > 0:
                subprocess.call([
                    'notify-send', f'[{name}] New email', '\n'.join([
                        f'[{box}] hash {mails[box]} new emails' for box in mails
                        if mails[box] > 0
                    ])
                ])
        except Exception as ec:
            update(-255)
            subprocess.call(['notify-send', 'Email check failed', str(ec)])


    def sig_update(_signum, _sig_frame):
        event.set()


    if __name__ == '__main__':
        if len(sys.argv) < 4:
            update(-255)
            sys.exit(-255)

        signal.signal(signal.SIGRTMIN + 1, sig_update)
        event.set()
        while True:
            event.wait(timeout=300)
            fetch_mail()
            event.clear()
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/starter"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "mpris" ];
        modules-right = [
          "tray"
          "custom/email#koumakan"
          "custom/email#nexa4ai"
          "network"
          "wireplumber"
          "temperature"
          "memory"
          "battery"
          "clock"
        ];
        "custom/starter" = {
          format = "{}";
          exec = "echo ' '";
          tooltip = false;
          on-click = "wofi";
          on-click-middle = "sleep 2 && hyprctl dispatch dpms off";
          on-click-right = "wpaperctl next";
          on-triple-click-right = "hyprctl dispatch exit";
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "active" = " ";
            "default" = " ";
          };
        };
        "hyprland/window" = {
          separate-outputs = true;
          format = "{title:.48}";
        };
        mpris = {
          format = "{status_icon} - {title} - {position}/{length}";
          tooltip-format = ''
            {player}
            status: {status_icon} {position}/{length}
            title:  {title}
            artist: {artist}
            album:  {album}'';
          status-icons = {
            playing = "";
            paused = "";
            stopped = "";
          };
          title-len = 32;
          interval = 1;
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
        };
        tray = {
          icon-size = 14;
          spacing = 5;
        };
        "custom/email#koumakan" = {
          exec = "${waybar-email-daemon}/bin/waybar-email-daemon koumakan imap.exmail.qq.com INBOX 其他文件夹/ccsvc 其他文件夹/github";
          restart-interval = 60;
          format = "{}";
          tooltip-format = "koumakan";
          on-click = "alacritty -e neomutt -e 'source ~/.config/neomutt/koumakan'";
          on-click-right = "pkill -SIGRTMIN+1 -f 'waybar-email-daemon koumakan'";
        };
        "custom/email#nexa4ai" = {
          exec = "${waybar-email-daemon}/bin/waybar-email-daemon nexa4ai imap.gmail.com INBOX";
          restart-interval = 60;
          format = "{}";
          tooltip-format = "nexa4ai";
          on-click = "alacritty -e neomutt -e 'source ~/.config/neomutt/nexa4ai'";
          on-click-right = "pkill -SIGRTMIN+1 -f 'waybar-email-daemon nexa4ai'";
        };
        network = {
          format = "{bandwidthUpBytes:>} {bandwidthDownBytes:>}";
          format-ethernet = "  {bandwidthDownBytes:>}  {bandwidthUpBytes:>} ";
          format-wifi = "{icon} {bandwidthDownBytes:>}  {bandwidthUpBytes:>} ";
          format-linked = " ";
          format-disconnected = " ";
          format-disabled = " ";
          format-icons = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
          tooltip-format = "{ifname}\n\n{ipaddr}/{cidr} - {gwaddr}";
          tooltip-format-wifi = "{ifname}\n\n{ipaddr}/{cidr} - {gwaddr}\n\n{essid} - {frequency} - {signalStrength}%";
          interval = 1;
          on-click = "alacritty -e nmtui";
        };
        wireplumber = {
          format = " {volume}%";
          format-muted = "<span color='red'> {volume}%</span>";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "alacritty -e pulsemixer";
        };
        temperature = {
          format = " {temperatureC}°C";
          critical-threshold = 70;
          tooltip = false;
          interval = 3;
        };
        memory = {
          format = "  {percentage}%";
          tooltip-format = ''
            mem:  {percentage}%
            {used:0.1f}G/{total:0.1f}G

            swap: {swapPercentage}%
            {swapUsed:0.1f}G/{swapTotal:0.1f}G'';
          interval = 3;
          on-click = "alacritty -e htop";
        };
        battery = {
          format = "{icon}󱐥";
          format-discharging = "{icon} {time}";
          format-charging = "{icon}󱐋 {time}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
          format-time = "{H}:{m}";
          tooltip-format = ''
            Cap:    {capacity}%
            Power:  {power}W
            Cycles: {cycles}
            Health: {health}%'';
          states = {
            warning = 30;
            critical = 15;
          };
          interval = 5;
        };
        clock = {
          locale = "en_US.UTF-8";
          format = " {:%H:%M}";
          tooltip-format = "<tt><span size='11pt'>{calendar}</span></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 4;
            weeks-pos = "left";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'>{}</span>";
              days = "<span color='#ecc6d9'>{}</span>";
              weeks = "<span color='#99ffdd'>W{:%W}</span>";
              weekdays = "<span color='#ffcc66'>{}</span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
      };
    };
    style = ''
      * {
          min-height: 0;
          font-family: monospace;
          font-size: 13px;
          font-weight: 300;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background: transparent;
      }

      tooltip {
          border: 2px solid rgba(89, 89, 89, 0.85);
          border-radius: 8px;
          background: rgba(33, 33, 33, 0.85);
      }

      tooltip label {
          color: #f5e0dc;
      }

      #custom-starter, #workspaces, #window, #mpris, #tray, #custom-email, #network, #wireplumber, #temperature, #memory, #battery, #clock {
          border: 2px solid rgba(89, 89, 89, 0.85);
          border-radius: 8px;
          margin-top: 5px;
          margin-right: 5px;
          padding: 0px 5px 0px 5px;
          background: rgba(33, 33, 33, 0.85);
      }

      #custom-starter {
          margin-left: 5px;
          color: #94e2d5;
      }

      #workspaces button {
          color: #f5e0dc;
      }
      #workspaces button.active {
          color: #89b4fa;
      }
      #workspaces button.urgent {
          color: #f38ba8;
      }

      #window {
          color: #cba6f7;
      }
      window#waybar.empty #window {
          opacity: 0;
          margin: 0;
          padding: 0;
          border: none;
      }

      #mpris {
          color: #fab387;
      }

      #tray * {
          margin: unset;
          padding: unset;
          font-family: unset;
          font-size: unset;
      }

      #custom-email {
          color: #94e2d5;
      }

      #network {
          color: #89b4fa;
      }

      #wireplumber {
          color: #f2cdcd;
      }

      #temperature {
          color: #f38ba8;
      }
      #temperature.critical {
          color: #ffa500;
      }

      #memory {
          color: #f9e2af;
      }

      #battery {
          color: #89dceb;
      }
      #battery.discharging.warning {
          color: #ffa500;
      }
      #battery.discharging.critical {
          color: #ff0000;
      }

      #clock {
          margin-right: 5px;
          color: #b4befe;
      }
    '';
  };
}
