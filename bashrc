#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.git-prompt.sh
export PS1='\[\e[34m\]┌[\[\e[32m\]\u\[\e[35m\]@\[\e[36m\]\H\[\e[34m\]]-[\[\e[35m\]\t\[\e[34m\]]-[\[\e[33m\]\w\[\e[34m\]]\[\e[0m\]$(echo -e "$(__git_ps1)") $DEF_PROXY \n\[\e[34m\]└[\[\e[35m\]\$\[\e[34m\]]\[\e[0m\] '

export TERM=xterm-termite
alias ssh='TERM=xterm-256color /usr/bin/ssh'

# replaced utils
alias ls='/usr/bin/exa'
alias ll='/usr/bin/exa -bghHliS'
alias grep='/usr/bin/rg'
alias ncdu='/usr/bin/ncdu --color=dark'
alias ping='/usr/bin/prettyping'
alias cat='/usr/bin/bat'
export BAT_PAGER="less -RF"
export BAT_THEME=OneHalfDark
source /usr/share/skim/key-bindings.bash
source /usr/share/skim/completion.bash
export SKIM_DEFAULT_OPTIONS="--no-mouse --preview-window right:70% --bind '?:toggle-preview,ctrl-o:execute-silent(xdg-open {})'"
export SKIM_CTRL_T_OPTS="--preview 'bat --color always {}'"

source ~/.ranger-cd.sh

alias ssp='source setproxy.sh'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'
alias disgit='__git_ps1() { echo " (disabled)"; }'

alias py='/usr/bin/ipython'
alias latexmk='latexmk -interaction=nonstopmode'
alias vims='/usr/bin/vim --servername VIM'
alias tig='/usr/bin/tig --date-order --all'

alias exeg++='/usr/bin/x86_64-w64-mingw32-g++'
alias exegcc='/usr/bin/x86_64-w64-mingw32-gcc'
alias execmake='/usr/bin/x86_64-w64-mingw32-cmake'

# Rust
#export CARGO_INCREMENTAL=0
export RUST_SRC_PATH=$HOME/.cargo/src
cargo_wasm() {
    cargo $@ --target=wasm32-unknown-unknown
}
cargo_linux() {
    cargo $@ --target=x86_64-unknown-linux-gnu
}
cargo_musl() {
    cargo $@ --target=x86_64-unknown-linux-musl
}
cargo_aarch64() {
    cargo $@ --target=aarch64-unknown-linux-gnu
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

#export DOCKER_TLS_VERIFY="1"
#export DOCKER_HOST="tcp://192.168.99.102:2376"
#export DOCKER_CERT_PATH="/home/remilia/.docker/machine/machines/default"
#export DOCKER_MACHINE_NAME="default"

http_login() {
    export HTTP_JWT_TOKEN=`http $@/api/login username=admin password='' | jq -r '.data | .token'`
    echo $HTTP_JWT_TOKEN
}
http_login_raw() {
    export HTTP_JWT_TOKEN=`http $@/api/login username=admin password='' | jq -r '.data | .token'`
    echo $HTTP_JWT_TOKEN
}
http_auth() {
    http --pretty=all -p hb $@ Authorization:"Bearer $HTTP_JWT_TOKEN" > /tmp/httpie_res
    NEW_TOKEN=`cat /tmp/httpie_res | rg Refresh-Token | awk '{print $2}'`
    if [ -n "$NEW_TOKEN" ]; then
        export HTTP_JWT_TOKEN=$NEW_TOKEN
    fi
    /bin/cat /tmp/httpie_res
    rm /tmp/httpie_res
}
