#
# ~/.bash_profile
#


export HISTSIZE=16384

export PATH=./node_modules/.bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

export MAKEFLAGS='-j32'
export WINEESYNC=1

export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/vim'
export BROWSER='/usr/bin/firefox'
#export TERM=xterm-termite

# GO
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH
#export GO111MODULE=on
export GOPROXY=https://goproxy.io
export GOPRIVATE=gitlab.deepglint.com
# Python
export PYTHONPYCACHEPREFIX=$HOME/.cache/python

#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

. $HOME/.bashrc

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
