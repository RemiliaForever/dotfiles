{ pkgs, ... }:

{
  programs.bash.profileExtra = ''
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && hyprland
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
    systemd = {
      enable = true;
    };
    settings = {
      monitor = ",preferred,auto,auto";
      xwayland.force_zero_scaling = false;

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "swww-daemon"
        "swww-control"
        "waybar"
        "mako"
        "hypridle"

        "fcitx5"
        "nm-applet"

        "nextcloud"
        "flameshot"
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

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        blur.enabled = false;
      };

      animations = {
        enabled = true;
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

        "SUPER, w, killactive"
        "SUPER, p, pseudo"
        "SUPER, s, fullscreen, 0"
        "SUPER, m, fullscreen, 1"
        "SUPER, space, togglefloating"

        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER_CONTROL, k, resizeactive, 0 -20"
        "SUPER_CONTROL, j, resizeactive, 0 20"
        "SUPER_CONTROL, h, resizeactive, -20 0"
        "SUPER_CONTROL, l, resizeactive, 20 0"
        "SUPER_SHIFT, k, swapwindow, u"
        "SUPER_SHIFT, j, swapwindow, d"
        "SUPER_SHIFT, h, swapwindow, l"
        "SUPER_SHIFT, l, swapwindow, r"

        "SUPER, f, cyclenext, floating"
        "SUPER, b, cyclenext, pre floating"
        "SUPER, f, alterzorder, top"
        "SUPER, b, alterzorder, top"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 0"
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
        "SUPER_SHIFT, 6, movetoworkspace, 6"
        "SUPER_SHIFT, 7, movetoworkspace, 7"
        "SUPER_SHIFT, 8, movetoworkspace, 8"
        "SUPER_SHIFT, 9, movetoworkspace, 9"
        "SUPER_SHIFT, 0, movetoworkspace, 0"
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
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

      windowrulev2 = [ ];
    };
  };
}
