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
#export GOPROXY=https://goproxy.io
export GOPRIVATE=gitlab.deepglint.com
# Python
export PYTHONPYCACHEPREFIX=$HOME/.cache/python
export PATH=$HOME/.python/bin:$PATH
# Java
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export PATH=$HOME/.gradle/bin:$PATH
# JavaScript
export PATH=./node_modules/.bin:$HOME/.js/bin:$PATH


. $HOME/.bashrc

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
