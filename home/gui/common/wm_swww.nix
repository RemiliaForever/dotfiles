{ pkgs, ... }:

let
  swww-control = pkgs.writers.writePython3Bin "swww-control" { } ''
    import fcntl
    import os
    import random
    import signal
    import subprocess
    import time
    import threading

    images = []
    event = threading.Event()


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


    def sig_change(_signum, _sig_frame):
        event.set()


    if __name__ == '__main__':
        uid = os.getuid()
        f = open(f'/run/user/{uid}/swww-control.lock', 'w')
        fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)

        dir = os.path.expanduser('~/.background')
        for root, dirs, files in os.walk(dir, followlinks=True):
            for file in files:
                images.append(f'{root}/{file}')

        # fix swww first call no effect
        change()
        signal.signal(signal.SIGRTMIN+1, sig_change)
        event.set()
        while True:
            event.wait(timeout=300)
            change()
            event.clear()
            time.sleep(1)
  '';
in
{
  home.packages = with pkgs; [
    swww
    swww-control
  ];
}
