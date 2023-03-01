import subprocess

from libqtile import hook

import binding
import group
import screen
import rule

import element

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
wmname = 'LG3D'

notifier = element.Notifier(
    x=3430,
    y=64,
    font='Noto Sans Mono CJK SC',
    font_size=28,
    opacity=0.85,
    width=384,
    height=128,
    overflow='more_width',
)


@hook.subscribe.startup_complete
def autostart():
    subprocess.Popen(['picom', '--experimental-backends', '--config', '/home/remilia/.config/picom/config'])
    subprocess.Popen(['fcitx5', '-D', '-r'])
    subprocess.Popen(['blueman-applet'])
