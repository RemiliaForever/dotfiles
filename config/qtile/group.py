from libqtile.config import Group, Match

groups = [
    Group('1', label='🖥️'),
    Group('2', label='🖥️'),
    Group('3', label='🖥️'),
    Group('4', label='🌐', matches=[Match(wm_class='firefox')]),
    Group('5', label='🖥️'),
    Group('6', label='💬', matches=[Match(wm_class='bytedance-feishu')], layout='floating'),
    Group('7', label='📄', matches=[Match(wm_class='weixin')], layout='floating'),
    Group('8', label='📀', matches=[Match(wm_class='netease-cloud-music-gtk4')]),
]
