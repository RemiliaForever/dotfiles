{ pkgs, lib, ... }:

{

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common.default = "hyprland";
    };
  };
  # disable xdg autostart
  home.activation.hyprland = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf /dev/null /home/remilia/.config/systemd/user/xdg-desktop-autostart.target
  '';
  # fix uwsm leak python
  programs.bash.bashrcExtra = ''
    # Hyprland
    if [ -n "$DESKTOP_SESSION" ] && [ "$SHLVL" -eq 2 ] || [ "$SHLVL" -eq 1 ]; then
        export PATH="/run/wrappers/bin:$HOME/.nix-profile/bin:$XDG_STATE_HOME/nix/profile/bin:$HOME/.local/state/nix/profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    fi
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    plugins = with pkgs.hyprlandPlugins; [
      hyprsplit
      hyprspace
      hyprgrass
      hyprwinwrap
    ];
    settings = {
      general = {
        border_size = 2;
        gaps_in = 3;
        gaps_out = 6;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur.enabled = false;
      };
      animations = {
        enabled = true;
      };
      input = {
        follow_mouse = 1;
        follow_mouse_threshold = 32;
        scroll_method = "2fg";
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_touch = true;
      };
      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = false;
        focus_on_activate = true;
        allow_session_lock_restore = true;
        disable_xdg_env_checks = true;
        disable_hyprland_qtutils_check = true;
        enable_anr_dialog = false;
      };
      xwayland.force_zero_scaling = true;
      render.expand_undersized_textures = false;
      cursor.no_hardware_cursors = 2;

      exec-once = [
        "kwalletd6"
        "mako"
        "hypridle"
        "wpaperd"

        "sleep 1 && waybar"

        "sleep 2 && waybar-email-daemon"
        "sleep 2 && fcitx5 -r"
        "sleep 2 && blueman-applet"

        "sleep 5 && nextcloud"
      ];
      env = [ ];

      bind = [
        "SUPER, R, exec, wofi"
        "SUPER, Return, exec, alacritty"
        "SUPER CONTROL, Q, exit"
        "SUPER, Tab, overview:toggle, toggle"
        "SUPER, Delete, exec, loginctl lock-session"

        "SUPER, W, killactive"
        "SUPER, P, pseudo"
        "SUPER, M, fullscreen, 0"
        "SUPER, Space, togglefloating"

        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, O, focusmonitor, +1"
        "SUPER_SHIFT, K, movewindow, u"
        "SUPER_SHIFT, J, movewindow, d"
        "SUPER_SHIFT, H, movewindow, l"
        "SUPER_SHIFT, L, movewindow, r"
        "SUPER_SHIFT_CONTROL, K, swapwindow, u"
        "SUPER_SHIFT_CONTROL, J, swapwindow, d"
        "SUPER_SHIFT_CONTROL, H, swapwindow, l"
        "SUPER_SHIFT_CONTROL, L, swapwindow, r"

        "SUPER, F, cyclenext, floating"
        "SUPER, B, cyclenext, pre floating"
        "SUPER, F, alterzorder, top"
        "SUPER, B, alterzorder, top"

        "SUPER, 1, split:workspace, 1"
        "SUPER, 2, split:workspace, 2"
        "SUPER, 3, split:workspace, 3"
        "SUPER, 4, split:workspace, 4"
        "SUPER, 5, split:workspace, 5"
        "SUPER, 6, split:workspace, 6"
        "SUPER, mouse_down, split:workspace, e-1"
        "SUPER, mouse_up, split:workspace, e+1"

        "SUPER_SHIFT, 1, split:movetoworkspace, 1"
        "SUPER_SHIFT, 2, split:movetoworkspace, 2"
        "SUPER_SHIFT, 3, split:movetoworkspace, 3"
        "SUPER_SHIFT, 4, split:movetoworkspace, 4"
        "SUPER_SHIFT, 5, split:movetoworkspace, 5"
        "SUPER_SHIFT, 6, split:movetoworkspace, 6"
        "SUPER_SHIFT, o, movewindow, mon:+1"
        "SUPER_SHIFT_CONTROl, O, split:swapactiveworkspaces, current +1"
        "SUPER_SHIFT, G, split:grabroguewindows"

        ", Print, exec, Hyprshot region"
        "CONTROL, Print, exec, Hyprshot window"
        "SHIFT, Print, exec, Hyprshot output"
        "SHIFT_CONTROl, Print, exec, Hyprshot all"
        "SUPER, Print, exec, Hyprshot region save"
        "SUPER_CONTROL, Print, exec, Hyprshot window save"
        "SUPER_SHIFT, Print, exec, Hyprshot output save"
        "SUPER_SHIFT_CONTROl, Print, exec, Hyprshot all save"

      ];
      binde = [
        "SUPER_CONTROL, K, resizeactive, 0 -20"
        "SUPER_CONTROL, J, resizeactive, 0 20"
        "SUPER_CONTROL, H, resizeactive, -20 0"
        "SUPER_CONTROL, L, resizeactive, 20 0"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"

        ", switch:on:Lid Switch, exec, loginctl lock-session"
        ", switch:on:Lid Switch, dpms, off"
        ", switch:on:Lid Switch, exec, wpaperctl pause"
        ", switch:off:Lid Switch, dpms, on"
        ", switch:off:Lid Switch, exec, wpaperctl resume"
      ];

      windowrule = [
        "float, class:(Bytedance-feishu), title:(图片)"
        "float, class:(Bytedance-lark), title:(图片)"

        "float, title:(Lark会议)"
        "noshadow, class:^()$, title:(Lark会议)"
        "noshadow, class:^(Meeting)$, title:(Lark会议)"

        "float, class:(wechat), title:(预览)"

        "float, title:(MainPicker)"
        "float, class:(nm-connection-editor)"
        "float, class:(.blueman-manager-wrapped)"

        "renderunfocused, class:(starrail.exe)" # fix fps limit
        "tile, class:(starrail.exe)"
        "renderunfocused, title:(魔兽世界)"
      ];

      workspace = [ ];

      animation = [
        "windows, 1, 3, default"
        "workspaces, 1, 5, default"
      ];

      dwindle.preserve_split = true;

      plugin = {
        hyprsplit = {
          num_workspaces = 6;
          persistent_workspaces = true;
        };

        overview = {
          workspaceActiveBorder = "rgba(33ccffee)";
          workspaceInactiveBorder = "rgba(595959aa)";
          disableBlur = true;

          panelHeight = 180;
          reservedArea = 32;
          workspaceBorderSize = 2;
          overrideGaps = false;

          hideRealLayers = false;
          showNewWorkspace = false;
          exitOnSwitch = true;
        };

        touch_gestures = {
          sensitivity = 16.0;
          workspace_swipe_fingers = 3;
          workspace_swipe_edge = "d";
          long_press_delay = 400;
          resize_on_border_long_press = true;
          edge_margin = 10;
        };

        hyprwinwrap = {
          class = "winwrap";
        };
      };
    };
  };
}
