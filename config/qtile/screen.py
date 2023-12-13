from libqtile import bar, layout, widget
from libqtile.config import Screen

import widget as w

border = {
    'border_width': 5,
    'border_focus': '#66ccff',
    'border_normal': '#666666',
    'border_on_single': True,
}

layouts = [
    layout.Columns(num_columns=2, **border),
    layout.MonadWide(**border),
    layout.Matrix(**border),
    layout.Floating(**border),
    layout.Max(**border),
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
                    urgent_alert_method='block',
                    inactive='ffffff',
                ),
                widget.Prompt(),
                widget.WindowTabs(background='333333', margin=50),
                #widget.Mpris2(
                #    width=512,
                #    background='333333',
                #    paused_text='<span color="yellow">{track}</span>',
                #    playing_text='<span color="green">{track}</span>',
                #    no_metadata_text='<span color="grey">unknown</span>',
                #    scroll_fixed_width=True,
                #),
                w.Net(),
                w.Mem(),
                w.CPU(),
                w.Volume(),
                w.Mail('', '', ''),
                w.Mail('', '', ''),
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
                    urgent_alert_method='block',
                    inactive='ffffff',
                ),
                widget.WindowTabs(background='333333', margin=50),
                widget.CurrentLayoutIcon(padding=10),
            ],
            42,
            opacity=0.7,
        ),
    )
]
