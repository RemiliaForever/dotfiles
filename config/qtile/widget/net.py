from datetime import datetime

from libqtile.widget import base


class Net(base.InLoopPollText):

    def __init__(self):
        super().__init__("", update_interval=1)
        self.name = ''
        self.recv = 0
        self.send = 0
        self.last = datetime.now().timestamp()

    def format_net(self, num: float) -> str:
        num = num / 1024
        if num > 1024:
            return f'<span weight="bold">{int(num/1024):3} MB</span>'
        else:
            return f'{int(num):3} KB'

    def netstat(self):
        netif = ''
        for line in open('/proc/net/route').readlines():
            net, dest = line.split()[:2]
            if dest == '00000000':
                netif = net
        if not netif:
            raise Exception('not found')

        recv, send = 0, 0
        for line in open('/proc/net/dev').readlines():
            data = line.split()
            if data[0][:-1] != netif:
                continue
            recv = int(data[1])
            send = int(data[9])
        if recv == 0 or send == 0:
            raise Exception('get data failed')

        now = datetime.now().timestamp()
        down = (recv - self.recv) / (now - self.last)
        up = (send - self.send) / (now - self.last)

        self.recv = recv
        self.send = send
        self.last = now

        if self.name != netif:
            self.name = netif
            raise Exception('first init')

        result = ''
        result += f'🔻<span color="#c2ba62">{self.format_net(down)}</span>'
        result += f'🔺<span color="#5798d9">{self.format_net(up)}</span>'
        return result

    def poll(self):
        try:
            return self.netstat()
        except Exception:
            return '(no network)'
