from datetime import datetime

from libqtile.widget import base


class Net(base.InLoopPollText):

    def __init__(self):
        super().__init__("", update_interval=1)
        self.name = ''
        self.recv = 0
        self.send = 0
        self.last = datetime.now().timestamp()

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
        down = int((recv - self.recv) / (now - self.last) / 1024)
        up = int((send - self.send) / (now - self.last) / 1024)

        self.recv = recv
        self.send = send
        self.last = now

        if self.name != netif:
            self.name = netif
            raise Exception('first init')

        result = ''
        result += f'🔻<span color="#c2ba62">{down:5} KB</span>'
        result += f'🔺<span color="#5798d9">{up:5} KB</span>'
        return result

    def poll(self):
        try:
            return self.netstat()
        except Exception:
            return '(no network)'
