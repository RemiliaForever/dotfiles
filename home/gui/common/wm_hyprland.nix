{ pkgs, ... }:

{
  programs.bash.profileExtra = ''
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec Hyprland
  '';
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common.default = "hyprland";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprsplit
      hyprspace
      hyprgrass
      hyprwinwrap
    ];
    settings = {
      monitor = [ ",preferred,auto,2" ];
      xwayland.force_zero_scaling = true;

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP LC_ALL"
        "swww-daemon"
        "swww-control"
        "waybar"
        "mako"
        "hypridle"

        "fcitx5 -r"
        "nm-applet"
        "blueman-applet"

        #"nextcloud"
      ];

      env = [ ];

      general = {
        border_size = 2;
        gaps_in = 3;
        gaps_out = 6;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        resize_on_border = false;
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

      cursor = {
        no_hardware_cursors = 2;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_touch = true;
      };

      misc = {
        disable_autoreload = false;
        disable_hyprland_logo = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };

      bind = [
        "SUPER, r, exec, wofi"
        "SUPER, return, exec, wezterm"
        "SUPER CONTROL, r, exit"
        "SUPER CONTROL, q, exit"
        "SUPER, tab, overview:toggle, toggle"
        "SUPER, delete, exec, loginctl lock-session "

        "SUPER, w, killactive"
        "SUPER, p, pseudo"
        "SUPER, s, fullscreen, 0"
        "SUPER, m, fullscreen, 1"
        "SUPER, space, togglefloating"

        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, o, focusmonitor, +1"
        "SUPER_SHIFT, k, movewindow, u"
        "SUPER_SHIFT, j, movewindow, d"
        "SUPER_SHIFT, h, movewindow, l"
        "SUPER_SHIFT, l, movewindow, r"
        "SUPER_SHIFT_CONTROL, k, swapwindow, u"
        "SUPER_SHIFT_CONTROL, j, swapwindow, d"
        "SUPER_SHIFT_CONTROL, h, swapwindow, l"
        "SUPER_SHIFT_CONTROL, l, swapwindow, r"

        "SUPER, f, cyclenext, floating"
        "SUPER, b, cyclenext, pre floating"
        "SUPER, f, alterzorder, top"
        "SUPER, b, alterzorder, top"

        "SUPER, 1, split:workspace, 1"
        "SUPER, 2, split:workspace, 2"
        "SUPER, 3, split:workspace, 3"
        "SUPER, 4, split:workspace, 4"
        "SUPER, 5, split:workspace, 5"
        "SUPER, mouse_down, split:workspace, e-1"
        "SUPER, mouse_up, split:workspace, e+1"

        "SUPER_SHIFT, 1, split:movetoworkspace, 1"
        "SUPER_SHIFT, 2, split:movetoworkspace, 2"
        "SUPER_SHIFT, 3, split:movetoworkspace, 3"
        "SUPER_SHIFT, 4, split:movetoworkspace, 4"
        "SUPER_SHIFT, 5, split:movetoworkspace, 5"
        "SUPER_SHIFT, o, movewindow, mon:+1"
        "SUPER_SHIFT_CONTROl, o, split:swapactiveworkspaces, current +1"
        "SUPER_SHIFT, g, split:grabroguewindows"
      ];
      binde = [
        "SUPER_CONTROL, k, resizeactive, 0 -20"
        "SUPER_CONTROL, j, resizeactive, 0 20"
        "SUPER_CONTROL, h, resizeactive, -20 0"
        "SUPER_CONTROL, l, resizeactive, 20 0"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      bindl = [
        ", switch:on:Lid Switch, exec, loginctl lock-session"
        ", switch:on:Lid Switch, dpms, off"
        ", switch:off:Lid Switch, dpms, on"
      ];

      windowrulev2 = [
        "float, class:(Bytedance-feishu), title:(图片)"
        "float, class:(wechat), title:(预览)"
      ];

      workspace = [ ];

      plugin = {
        hyprsplit = {
          num_workspaces = 5;
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
          sensitivity = 8.0;
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
