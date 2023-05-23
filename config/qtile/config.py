import subprocess

from libqtile import hook, qtile

import binding
import element
import group
import rule
import screen

keys = binding.keys
mouse = binding.mouse
groups = group.groups
layouts = screen.layouts
screens = screen.screens
floating_layout = rule.floating_layout

widget_defaults = dict(
    font='Noto Sans Mono',
    fontsize=28,
    padding=10,
)
extension_defaults = widget_defaults.copy()

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = True
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = True
auto_minimize = True
wmname = 'Qtile'

notifier = element.Notifier(
    x=3430,
    y=64,
    font='Noto Sans Mono CJK SC',
    font_size=32,
    opacity=0.85,
    width=384,
    height=128,
    icon_size=64,
    overflow='more_width',
    max_windows=8,
    background=['333333', '111111', '881111'],
)


@hook.subscribe.startup
def startup():
    if len(qtile.screens) > 1:
        qtile.groups_map['1'].cmd_toscreen(0, toggle=False)
        qtile.groups_map['5'].cmd_toscreen(1, toggle=False)


@hook.subscribe.client_focus
def client_focus(window):
    if window.floating:
        window.cmd_bring_to_front()


@hook.subscribe.startup_complete
def startup_complete():
    subprocess.Popen(['picom', '--config', '/home/remilia/.config/picom/config'])
    subprocess.Popen(['fcitx5', '-D', '-r'])
    subprocess.Popen(['blueman-applet'])
    if qtile.core.name == 'wayland':
        subprocess.Popen([
            'wlr-randr', '--output', 'DP-3', '--on', '--mode', '3840x2160', '--preferred', '--pos', '0,0', '--scale',
            '2', '--output', 'DP-1', '--on', '--mode', '3840x2160', '--preferred', '--pos', '3840,0', '--scale', '2'
        ])
