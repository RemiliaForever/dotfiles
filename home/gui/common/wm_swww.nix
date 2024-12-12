{ pkgs, ... }:

let
  swww-control = pkgs.writers.writePython3Bin "swww-control" { } ''
    import fcntl
    import os
    import random
    import signal
    import subprocess
    import time

    images = []
    count = 3000


    def change():
        global images
        for line in subprocess.getoutput('hyprctl monitors').splitlines():
            if 'dpmsStatus: 0' in line:
                return
        cmd = [
            'swww', 'img',
            random.choice(images), '--transition-type', 'simple',
            '--transition-step', '8', '--transition-fps', '60'
        ]
        subprocess.call(cmd)


    def siguser1(_signum, _sig_frame):
        global count
        count = 3000


    if __name__ == '__main__':
        uid = os.getuid()
        display = os.environ.get('WAYLAND_DISPLAY')
        f = open(f'/run/user/{uid}/swww-control-{display}.pid', 'w')
        fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
        f.write(str(os.getpid()))
        f.flush()

        dir = os.path.expanduser('~/.background')
        for root, dirs, files in os.walk(dir, followlinks=True):
            for file in files:
                images.append(f'{root}/{file}')

        # fix swww first call no effect
        change()
        signal.signal(signal.SIGUSR1, siguser1)
        while True:
            if count >= 3000:
                count = 0
                change()
                time.sleep(0.8)
            else:
                count += 1
            time.sleep(0.1)
  '';
in
{
  home.packages = with pkgs; [
    swww
    swww-control
  ];
}
