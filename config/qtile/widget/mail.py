import imaplib
import re
import subprocess
import threading

from libqtile.lazy import lazy
from libqtile.widget import base


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
                'Button1': lazy.spawn(f'alacritty -e mutt -F /home/remilia/.mutt/{self.username}/muttrc'),
                'Button3': Mail.lazy_force_update(self),
            },
        )

    @lazy.function
    def lazy_force_update(qtile, self):
        threading.Thread(target=self.force_update).start()

    def fetch_mail(self) -> int:
        e = Exception('Unknown')

        for s in [' ? ', ' ??', '???']:
            self.update(f'📩{s}')
            try:
                M = imaplib.IMAP4_SSL(self.server)
                M.login(self.username, self.password)
                M.select(readonly=True)
                s = M.status('INBOX', '(UNSEEN)')
                return int(re.search(r'UNSEEN\s+(\d+)', str(s)).group(1))  #type: ignore
            except Exception as ec:
                e = ec
        raise e

    def poll(self):
        try:
            c = self.fetch_mail()
            if c > 0:
                subprocess.Popen(['notify-send', self.username, f'您有 {c} 封新邮件'])
                return f'📭<span color="yellow">{c:^3}</span>'
            else:
                return f'📭<span color="white">{c:^3}</span>'
        except Exception as e:
            subprocess.Popen(['notify-send', self.username, f'更新失败 {e}'])
            return f'📭<span color="red">Err</span>'
