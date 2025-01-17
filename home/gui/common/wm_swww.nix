{ pkgs, ... }:

let
  swww-control = pkgs.writers.writePython3Bin "swww-control" { } ''
    import fcntl
    import logging
    import os
    import random
    import signal
    import subprocess
    import threading
    import time

    images = []
    event = threading.Event()

    logging.basicConfig(level=logging.INFO)
    log = logging.getLogger('swww-control')


    def change():
        global images
        log.info('change begin')
        for line in subprocess.getoutput('hyprctl monitors').splitlines():
            if 'dpmsStatus: 0' in line:
                return
        cmd = [
            'swww', 'img',
            random.choice(images), '--transition-type', 'simple',
            '--transition-step', '8', '--transition-fps', '60'
        ]
        subprocess.call(cmd)
        time.sleep(2)
        log.info('change end')


    def sig_change(_signum, _sig_frame):
        event.set()


    if __name__ == '__main__':
        # fix swww init
        subprocess.call(['swww', 'clear'])
        time.sleep(1)

        uid = os.getuid()
        f = open(f'/run/user/{uid}/swww-control.lock', 'w')
        fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)

        dir = os.path.expanduser('~/.background')
        for root, dirs, files in os.walk(dir, followlinks=True):
            for file in files:
                images.append(f'{root}/{file}')

        signal.signal(signal.SIGRTMIN + 1, sig_change)
        event.set()
        while True:
            log.info('wait')
            event.wait(timeout=300)
            change()
            event.clear()
  '';
in
{
  home.packages = with pkgs; [
    swww
    swww-control
  ];
}
