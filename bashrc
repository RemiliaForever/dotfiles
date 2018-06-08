#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export JAVA_HOME=/usr/lib/jvm/default
export PATH=$PATH:./node_modules/.bin
#export MESA_GL_VERSION_OVERRIDE=2.1
source /usr/share/git/completion/git-completion.bash
source ~/.git-prompt.sh

#export PS1_START='\r'
export PS1='\[\e[34m\]┌[\[\e[32m\]\u\[\e[35m\]@\[\e[32m\]\H\[\e[34m\]]-[\[\e[35m\]\t\[\e[34m\]]-[\[\e[33m\]\w\[\e[34m\]]\[\e[0m\]$(echo -e "$(__git_ps1)") $DEF_PROXY \n\[\e[34m\]└[\[\e[35m\]\$\[\e[34m\]]\[\e[0m\] '

export PAGER='/usr/bin/less'
export EDITOR='/usr/bin/vim'
export BROWSER='/usr/local/bin/firefox'

export TERM=xterm-256color

alias ls='/usr/bin/ls --color=always'
alias ll='/usr/bin/ls --color=always -lh'
alias grep='/usr/bin/grep --color=always'

alias exeg++='/usr/bin/x86_64-w64-mingw32-g++'
alias exegcc='/usr/bin/x86_64-w64-mingw32-gcc'
alias execmake='/usr/bin/x86_64-w64-mingw32-cmake'

alias ssp='source setproxy.sh'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'

alias yy='yaourt -Syua'
alias py='/usr/bin/ipython'
alias latexmk='latexmk -interaction=nonstopmode'

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
