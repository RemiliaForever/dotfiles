import subprocess
import threading

from libqtile.lazy import lazy
from libqtile.widget import base


class Volume(base.ThreadPoolText):

    def __init__(self):
        super().__init__(
            '',
            update_interval=10,
            mouse_callbacks={
                'Button1': Volume.pulsemixer(self, '--toggle-mute'),
                'Button3': lazy.spawn('alacritty -e pulsemixer'),
                'Button4': Volume.pulsemixer(self, '--change-volume +5'),
                'Button5': Volume.pulsemixer(self, '--change-volume -5'),
            },
        )

    @lazy.function
    def pulsemixer(qtile, self, param: str):

        def wrapper(param: str):
            subprocess.check_output(['pulsemixer', *param.split()])
            self.update(self.poll())

        threading.Thread(target=wrapper, args=(param, )).start()

    def get(self) -> str:
        volume = int(subprocess.check_output(['pulsemixer', '--get-volume']).decode().split()[0])
        mute = int(subprocess.check_output(['pulsemixer', '--get-mute']).decode().split()[0])

        if mute != 0:
            return f'🔇 {volume}<span color="red">M</span>'
        elif volume > 50:
            return f'🔊 {volume}%'
        else:
            return f'🔉 {volume}%'

    def poll(self):
        try:
            return self.get()
        except Exception:
            return f'🔇<span color="red">Err</span>'
