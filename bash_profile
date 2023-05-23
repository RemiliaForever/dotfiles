#
# ~/.bash_profile
#


export HISTSIZE=65535

export MAKEFLAGS='-j32'
export WINEESYNC=1

export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/nvim'
export BROWSER='/usr/bin/firefox'

# Rust
export CARGO_INCREMENTAL=1
export PATH=$HOME/.cargo/bin:$PATH
# GO
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH
export GOPRIVATE=gitlab.deepglint.com
# Python
export PYTHONPYCACHEPREFIX=$HOME/.cache/python
# Java
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
# Android
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NDK_ROOT=/opt/android-sdk/ndk/latest
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
# JavaScript
export PATH=./node_modules/.bin:$PATH

# etc
export PATH=$HOME/.local/bin:$PATH
# delinux
export PATH=$HOME/.local/delinux/aarch64-delinux-linux-gnu/bin:$PATH
export PATH=$HOME/.local/delinux/aarch64-delinux-linux-musl/bin:$PATH
export PATH=$HOME/.local/delinux/arm-delinux-linux-gnueabihf/bin:$PATH
export PATH=$HOME/.local/delinux/arm-delinux-linux-musleabihf/bin:$PATH
export PATH=$HOME/.local/delinux/mipsel-delinuxsf-linux-gnu/bin:$PATH
export PATH=$HOME/.local/delinux/mipsel-delinuxsf-linux-musl/bin:$PATH
export PATH=$HOME/.local/delinux/x86_64-delinux-linux-gnu/bin:$PATH
export PATH=$HOME/.local/delinux/x86_64-delinux-linux-musl/bin:$PATH

# Firefox HWAccel
export LIBVA_DRIVER_NAME=nvidia
export NVD_BACKEND=direct
export MOZ_DISABLE_RDD_SANDBOX=1

. $HOME/.bashrc

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
