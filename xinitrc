#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

# merge in defaults and keymaps

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export XMODIFIERS="@im=fcitx"
export XIM="fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
sudo nvidia-smi -pm 1
#exec startxfce4
compton --config ~/.config/compton/config &
exec awesome
