{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    programs.niri = {
      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to auto start niri-session on tty1 login.";
      };
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Custom niri configuration snippet to be appended to the main config.";
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      niri
      xwayland-satellite
    ];
    # programs.zsh.completionInit = ''eval "$(${pkgs.niri}/bin/niri completions zsh)"'';
    programs.zsh.loginExtra =
      if config.programs.niri.autoStart then
        ''
          # auto start
          if [[ "$(tty)" == "/dev/tty1" ]] ; then
              exec niri-session -l
          fi
        ''
      else
        "";
    home.file.".nv/nvidia-application-profiles-rc".text = ''
      {
        "rules": [ {
            "pattern": {
                "feature": "procname",
                "matches": "niri"
            },
            "profile": "Limit Free Buffer Pool On Wayland Compositors"
        } ],
        "profiles": [ {
            "name": "Limit Free Buffer Pool On Wayland Compositors",
            "settings": [ {
                "key": "GLVidHeapReuseRatio",
                "value": 0
            } ]
        } ]
      }
    '';
    xdg.configFile."niri/config.kdl".text = ''
      // Input

      input {
          touchpad {
              tap
              natural-scroll
          }
          disable-power-key-handling
          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="25%"
      }

      // Outputs

      // Key Bindings

      binds {
          Mod+Ctrl+Q                { quit; }
          Mod+Delete                allow-when-locked=true { spawn "swaylock"; }
          Mod+Ctrl+Delete           { spawn-sh "swaylock -f && sleep 1 && niri msg action power-off-monitors"; }
          Mod+Shift+Slash           { show-hotkey-overlay; }
          Mod+Tab                   repeat=false { toggle-overview; }
          Mod+R                     repeat=false { spawn "wofi"; }
          Mod+Return                repeat=false { spawn "alacritty"; }
          Mod+W                     repeat=false { close-window; }

          // Media keys
          Print                     { screenshot; }
          Ctrl+Print                { screenshot-window write-to-disk=false; }
          Mod+Ctrl+Print            { screenshot-window; }
          Alt+Print                 { screenshot-screen write-to-disk=false; }
          Mod+Alt+Print             { screenshot-screen; }
          Mod+Escape                allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          XF86AudioRaiseVolume      allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
          XF86AudioLowerVolume      allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
          XF86AudioMute             allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute          allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
          XF86AudioPrev             allow-when-locked=true { spawn "playerctl" "previous"; }
          XF86AudioNext             allow-when-locked=true { spawn "playerctl" "next"; }
          XF86AudioPlay             allow-when-locked=true { spawn "playerctl" "play-pause"; }
          XF86AudioStop             allow-when-locked=true { spawn "playerctl" "stop"; }

          // window, column, monitor
          Mod+H                     { focus-column-left; }
          Mod+J                     { focus-window-or-workspace-down; }
          Mod+K                     { focus-window-or-workspace-up; }
          Mod+L                     { focus-column-right; }
          Mod+WheelScrollUp         { focus-column-left; }
          Mod+WheelScrollDown       { focus-column-right; }
          Mod+Shift+H               { move-column-left; }
          Mod+Shift+J               { move-window-down-or-to-workspace-down; }
          Mod+Shift+K               { move-window-up-or-to-workspace-up; }
          Mod+Shift+L               { move-column-right; }
          Mod+O                     { focus-monitor-next; }
          Mod+Shift+O               { move-column-to-monitor-next; }
          // workspace
          Mod+1                     { focus-workspace 1; }
          Mod+2                     { focus-workspace 2; }
          Mod+3                     { focus-workspace 3; }
          Mod+4                     { focus-workspace 4; }
          Mod+5                     { focus-workspace 5; }
          Mod+6                     { focus-workspace 6; }
          Mod+Ctrl+WheelScrollUp    { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown  { focus-workspace-down; }
          Mod+Shift+1               { move-window-to-workspace 1; }
          Mod+Shift+2               { move-window-to-workspace 2; }
          Mod+Shift+3               { move-window-to-workspace 3; }
          Mod+Shift+4               { move-window-to-workspace 4; }
          Mod+Shift+5               { move-window-to-workspace 5; }
          Mod+Shift+6               { move-window-to-workspace 6; }

          // column
          Mod+BracketLeft           { consume-or-expel-window-left; }
          Mod+BracketRight          { consume-or-expel-window-right; }
          Mod+Comma                 { consume-window-into-column; }
          Mod+Period                { expel-window-from-column; }
          Mod+P                     { switch-preset-column-width; }
          Mod+S                     { maximize-column; }
          // Mod+S                     { expand-column-to-available-width; }
          Mod+Ctrl+S                { maximize-window-to-edges;}
          Mod+M                     { fullscreen-window; }
          Mod+MouseMiddle           { fullscreen-window; }
          Mod+C                     { center-column; }
          // Mod+Ctrl+C                { center-visible-columns; }
          Mod+Ctrl+H                { set-column-width "-5%"; }
          Mod+Ctrl+J                { set-window-height "+5%"; }
          Mod+Ctrl+K                { set-window-height "-5%"; }
          Mod+Ctrl+L                { set-column-width "+5%"; }
          Mod+Ctrl+R                { reset-window-height; }
          Mod+Space                 { toggle-window-floating; }
          Mod+F                     { switch-focus-between-floating-and-tiling; }
      }

      // Switch Events

      switch-events {
          lid-close                 { spawn "niri" "msg" "action" "power-off-monitors"; }
          lid-open                  { spawn "niri" "msg" "action" "power-on-monitors"; }
          // tablet-mode-on { }
          // tablet-mode-off { }
      }

      // Layout

      layout {
          gaps 5
          center-focused-column "never"
          preset-column-widths {
              proportion 0.3
              proportion 0.6
              proportion 0.9
          }
          default-column-width { proportion 0.6; }

          focus-ring {
              width 3
              active-color "#33ccffee"
              inactive-color "#00000000"
          }

          shadow {
              on
              softness 5
              spread 5
              offset x=0 y=0
              color "#00000070"
          }
      }

      // Named workspaces

      // Miscellaneous

      prefer-no-csd

      screenshot-path "~/Pictures/ScreenShot/%Y-%m-%d_%H-%M-%S.png"

      hotkey-overlay {
          skip-at-startup
          hide-not-bound
      }

      // Window Rules

      window-rule {
          draw-border-with-background false
          geometry-corner-radius 8
          clip-to-geometry true
          open-floating false
          open-maximized-to-edges false
          tiled-state true
      }

      window-rule {
          match app-id="xdg-desktop-portal-gnome"
          match app-id="polkit-gnome-authentication-agent-1"
          match title="图片"
          match title="视频"
          match title="Lark会议"

          open-floating true
      }

      window-rule {
          match app-id="^firefox$"
          match app-id="^Bytedance-lark$"
          match app-id="Remmina$"

          default-column-width {
              proportion 1.0
          }
      }

      window-rule {
          match app-id="starrail.exe"
          match app-id="yuanshen.exe"
          match app-id="steam_app_"
          match title="wiliwili"

          open-fullscreen true

          force-render true
          force-render-fps 60
      }

      // Layer Rules

      layer-rule {
          match namespace="^notifications$"

          block-out-from "screencast"
      }


      // Animations

      // Gestures

      gestures {
          hot-corners {
              off
          }
      }

      // Recent Windows

    ''
    + config.programs.niri.extraConfig;
  };
}
