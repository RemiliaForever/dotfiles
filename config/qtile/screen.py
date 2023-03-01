from libqtile import bar, widget
from libqtile import layout
from libqtile.config import Screen

import widget as w

layouts = [
    layout.Columns(border_width=0, border_focus='#ff3333'),
    layout.Matrix(border_width=0),
    layout.MonadTall(border_width=0),
    layout.MonadWide(border_width=0),
    layout.Max(border_width=0),
]

screens = [
    Screen(
        wallpaper='/home/remilia/.config/qtile/background.jpg',
        wallpaper_mode='stretch',
        top=bar.Bar(
            [
                widget.GroupBox(
                    visible_groups=['1', '2', '3', '4'],
                    highlight_method='block',
                    inactive='ffffff',
                ),
                widget.Prompt(),
                widget.WindowTabs(background='333333', margin=50),
                w.Net(),
                w.Mem(),
                w.CPU(),
                w.Volume(),
                w.Mail(),
                w.Mail(),
                widget.Systray(icon_size=36, padding=2),
                widget.Clock(format='%Y-%m-%d %H:%M:%S %a'),
                widget.CurrentLayoutIcon(padding=10),
            ],
            42,
            opacity=0.7,
        ),
    ),
    Screen(
        wallpaper='/home/remilia/.config/qtile/background.jpg',
        wallpaper_mode='stretch',
        top=bar.Bar(
            [
                widget.GroupBox(
                    visible_groups=['5', '6', '7', '8'],
                    highlight_method='block',
                    inactive='ffffff',
                    padding=5,
                ),
                widget.WindowTabs(),
                widget.CurrentLayoutIcon(padding=10),
            ],
            42,
            opacity=0.7,
        ),
    )
]
