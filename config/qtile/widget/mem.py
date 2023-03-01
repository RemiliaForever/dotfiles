from libqtile.widget import base


class Mem(base.InLoopPollText):

    def __init__(self):
        super().__init__("", update_interval=5)

    def meminfo(self):
        total, free, zfs = 0, 0, 0

        for line in open('/proc/meminfo').readlines()[:3]:
            k, v = line.split(':')
            v = v.split()[0]
            if k == 'MemAvailable':
                free = int(v)
            elif k == 'MemTotal':
                total = int(v)

        for line in open('/proc/spl/kstat/zfs/arcstats').readlines()[32:48]:
            k, _, v = line.split()
            if k == 'size':
                zfs = int(v) / 1024

        zfs_percent = int(zfs / total * 100)
        use_percent = int(100 - free / total * 100)

        result = 'Mem '
        result += f'<span color="#90ee90">{use_percent}</span>'
        result += f'<span color="#66ccff">({use_percent - zfs_percent})</span>'
        result += '%'
        return result

    def poll(self):
        try:
            return self.meminfo()
        except Exception:
            return 'Mem <span color="#ff0000">??</span>'
