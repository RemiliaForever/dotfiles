import subprocess

from libqtile import hook, qtile

import binding
import element
import group
import rule
import screen

#from libqtile.log_utils import logger

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
        qtile.groups_map['1'].toscreen(0, toggle=False)
        qtile.groups_map['5'].toscreen(1, toggle=False)


@hook.subscribe.client_focus
def client_focus(window):
    #logger.warn(window.name)
    #logger.warn(window._wm_class)
    if window.floating:
        window.bring_to_front()


@hook.subscribe.startup_complete
def startup_complete():
    subprocess.Popen(['picom', '--config', '/home/remilia/.config/picom/config'])
    subprocess.Popen(['fcitx5', '-D', '-r'])
    subprocess.Popen(['blueman-applet'])

    subprocess.Popen(['netease-cloud-music-gtk4'])
    subprocess.Popen(['feishu'])
    subprocess.Popen(['qq'])
    subprocess.Popen(['firefox'])
