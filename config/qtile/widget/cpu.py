import subprocess
from typing import Tuple

from libqtile.widget import base


class CPU(base.ThreadPoolText):

    def __init__(self):
        super().__init__("", update_interval=5)

    def sensors(self) -> Tuple[str, str | int]:
        for line in subprocess.check_output(['sensors']).decode().splitlines():
            if line.startswith('Tctl:'):
                tf = int(float(line.strip('Tctl: +°C')))
                if tf > 80:
                    return ('orange', tf)
                elif tf > 60:
                    return ('yellow', tf)
                else:
                    return ('green', tf)

        raise Exception('not found')

    def poll(self):
        try:
            color, text = self.sensors()
            return f'CPU <span color="{color}">{text}</span>°C'
        except Exception:
            return 'CPU <span color="red">??</span>°C'
