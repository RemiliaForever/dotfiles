import imaplib
import re
import subprocess
import threading

from libqtile.widget import base
from libqtile.lazy import lazy


class Mail(base.ThreadPoolText):

    def __init__(self, server: str, username: str, password: str):
        self.server = server
        self.username = username
        self.password = password
        self.updating = False
        super().__init__(
            "",
            update_interval=300,
            mouse_callbacks={
                'Button1': lazy.spawn('alacritty -e mutt'),
                'Button3': self.force_update(self),
            },
        )

    @lazy.function
    def force_update(qtile, self):
        threading.Thread(target=self.cmd_force_update).start()

    def mail(self) -> int:
        M = imaplib.IMAP4_SSL(self.server)
        M.login(self.username, self.password)
        M.select(readonly=True)
        s = M.status('INBOX', '(UNSEEN)')
        return int(re.search(r'UNSEEN\s+(\d+)', str(s)).group(1))

    def poll(self):
        try:
            self.update(f'📩 ? ')
            c = self.mail()
            if c > 0:
                subprocess.Popen(['notify-send', self.username, f'您有 {c} 封新邮件'])
                return f'📭<span color="yellow">{c:^3}</span>'
            else:
                return f'📭<span color="white">{c:^3}</span>'
        except Exception as e:
            subprocess.Popen(['notify-send', self.username, f'更新失败 {e}'])
            return f'📭<span color="red">Err</span>'
