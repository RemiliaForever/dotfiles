from libqtile.config import Match
from libqtile.layout.floating import Floating

import screen

floating_layout = Floating(
    **screen.border,
    float_rules=[
        *Floating.default_float_rules,
        Match(wm_class='Arandr'),
        Match(wm_class='Gimp'),
        Match(wm_class='Wine'),
        Match(wm_class='Minecraft'),
        Match(wm_class='steam'),
        Match(wm_class='Display'),
        Match(wm_class='Animation'),
        Match(wm_class='matplotlib'),
        Match(wm_class='Places'),
        Match(wm_class='spectacle'),
        Match(title='图片'),
    ],
)
