#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTSIZE=65535

export JAVA_HOME=/usr/lib/jvm/default
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/.cargo/bin
#export MESA_GL_VERSION_OVERRIDE=2.1
source /usr/share/git/completion/git-completion.bash
source ~/.git-prompt.sh
source ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/etc/bash_completion.d/*
source ~/.diesel_completion

export MAKEFLAGS='-j16'

#export PS1_START='\r'
export PS1='\[\e[34m\]┌[\[\e[32m\]\u\[\e[35m\]@\[\e[32m\]\H\[\e[34m\]]-[\[\e[35m\]\t\[\e[34m\]]-[\[\e[33m\]\w\[\e[34m\]]\[\e[0m\]$(echo -e "$(__git_ps1)") $DEF_PROXY \n\[\e[34m\]└[\[\e[35m\]\$\[\e[34m\]]\[\e[0m\] '

export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/vim'
export BROWSER='/usr/bin/firefox'

#export TERM=xterm-termite
alias ssh='TERM=xterm-256color /usr/bin/ssh'
alias dssh='TERM=xterm-256color docker-machine ssh'

# replaced utils
alias ls='/usr/bin/exa'
alias ll='/usr/bin/exa -bghHliS'
alias grep='/usr/bin/grep --color=always'
alias ncdu='/usr/bin/ncdu --color=dark'
alias ping='/usr/bin/prettyping'
alias cat='/usr/bin/bat'
export BAT_PAGER="less -RF"
export BAT_THEME=OneHalfDark
#source /usr/share/fzf/key-bindings.bash
#source /usr/share/fzf/completion.bash
source /usr/share/skim/key-bindings.bash
source /usr/share/skim/completion.bash
export SKIM_DEFAULT_OPTIONS="--preview-window right:70% --bind '?:toggle-preview,ctrl-o:execute-silent(xdg-open {})'"
export SKIM_CTRL_T_OPTS="--preview 'bat --color always {}'"

alias ssp='source setproxy.sh'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'
alias disgit='__git_ps1() { echo " (disabled)"; }'

alias py='/usr/bin/ipython'
alias latexmk='latexmk -interaction=nonstopmode'
alias vim='/usr/bin/vim --servername VIM'

alias exeg++='/usr/bin/x86_64-w64-mingw32-g++'
alias exegcc='/usr/bin/x86_64-w64-mingw32-gcc'
alias execmake='/usr/bin/x86_64-w64-mingw32-cmake'


alias cargo='/usr/bin/cargo -Z config-profile'
export CARGO_INCREMENTAL=0
cargo_linux() {
    cargo $@ --target=x86_64-unknown-linux-gnu
}
cargo_musl() {
    cargo $@ --target=x86_64-unknown-linux-musl
}
cargo_musl_aarch64() {
    cargo $@ --target=aarch64-unknown-linux-musl
}
cargo_windows() {
    cargo $@ --target=x86_64-pc-windows-gnu
}
cargo_android() {
    cargo $@ --target=aarch64-linux-android
}
cargo_android_arm() {
    cargo $@ --target=arm-linux-android
}
cargo_android_armv7() {
    cargo $@ --target=armv7-linux-android
}

export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
