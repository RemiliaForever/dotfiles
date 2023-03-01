from libqtile.config import Click, Drag, Key
from libqtile.lazy import lazy

mod = 'mod4'


@lazy.function
def toggle_group(qtile, i: int):
    i += qtile.current_screen.index * 4
    qtile.current_screen.set_group(qtile.groups[i - 1])


@lazy.function
def move_to_group(qtile, i: int):
    i += qtile.current_screen.index * 4
    qtile.current_window.cmd_togroup(str(i), switch_group=True)


@lazy.function
def move_to_screen(qtile):
    s = 1 if qtile.current_screen.index == 0 else 0
    g = qtile.screens[s].group.name
    qtile.current_window.cmd_togroup(g)
    qtile.cmd_next_screen()


@lazy.function
def unminimize(qtile):
    for w in qtile.current_group.windows:
        if w.minimized:
            w.toggle_minimize()
            return


keys = [
    # Switch between windows
    Key([mod], 'h', lazy.layout.left()),
    Key([mod], 'l', lazy.layout.right()),
    Key([mod], 'j', lazy.layout.down()),
    Key([mod], 'k', lazy.layout.up()),
    Key([mod], 'f', lazy.group.next_window()),
    Key([mod], 'b', lazy.group.prev_window()),
    Key([mod], 'o', lazy.next_screen()),
    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, 'shift'], 'h', lazy.layout.shuffle_left()),
    Key([mod, 'shift'], 'l', lazy.layout.shuffle_right()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_up()),
    # Grow windows. If current window is on the edge of screen and direction
    Key([mod], 'w', lazy.window.kill()),
    Key([mod], 'm', lazy.window.toggle_maximize()),
    Key([mod], 'n', lazy.window.toggle_minimize()),
    Key([mod], 'space', lazy.window.toggle_floating()),
    Key([mod, 'shift'], 'n', unminimize()),
    Key([mod, 'shift'], 'o', move_to_screen()),
    Key([mod, 'control'], 'h', lazy.layout.grow_left()),
    Key([mod, 'control'], 'l', lazy.layout.grow_right()),
    Key([mod, 'control'], 'j', lazy.layout.grow_down()),
    Key([mod, 'control'], 'k', lazy.layout.grow_up()),
    Key([mod, 'control'], 'n', lazy.layout.normalize()),
    # Spawn
    Key([mod], 'Return', lazy.spawn('alacritty')),
    Key([mod], 'r', lazy.spawncmd()),
    Key([], 'Print', lazy.spawn('spectacle')),
    Key([mod], 'Print', lazy.spawn('spectacle -r')),
    Key([mod], 'Delete', lazy.spawn('slock')),
    # Screen
    Key([mod], 'Tab', lazy.next_layout()),
    # Qtile
    Key([mod, 'control'], 'r', lazy.reload_config()),
    Key([mod, 'control'], 'q', lazy.shutdown()),
]

for i in range(1, 5):
    keys.extend([
        Key([mod], str(i), toggle_group(i)),
        Key([mod, 'shift'], str(i), move_to_group(i)),
    ])

mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]
