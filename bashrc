#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.git-prompt.sh
export PS1='\[\e[34m\]┌[\[\e[32m\]\u\[\e[35m\]@\[\e[36m\]\H\[\e[34m\]]-[\[\e[35m\]\t\[\e[34m\]]-[\[\e[33m\]\w\[\e[34m\]]\[\e[0m\]$(echo -e "$(__git_ps1)") $DEF_PROXY \n\[\e[34m\]└[\[\e[35m\]\$\[\e[34m\]]\[\e[0m\] '

export TERM=xterm-256color
alias ssh='TERM=xterm-256color /usr/bin/ssh'

# replaced utils
alias ls='/usr/bin/exa'
alias ll='/usr/bin/exa -bghHliS'
alias grep='/usr/bin/rg'
alias ncdu='/usr/bin/ncdu --color=dark'
alias ping='/usr/bin/prettyping'
alias cat='/usr/bin/bat'
alias diff='/usr/bin/delta'
export BAT_PAGER="less -RF"
export BAT_THEME=OneHalfDark
source /usr/share/skim/key-bindings.bash
source /usr/share/skim/completion.bash
export SKIM_DEFAULT_OPTIONS="--no-mouse --preview-window right:70% --bind '?:toggle-preview,ctrl-o:execute-silent(xdg-open {})'"
export SKIM_CTRL_T_OPTS="--preview 'bat --color always {}'"
# extend utils
source ~/.ranger-cd.sh

alias ssp='source setproxy.sh'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'
alias disgit='__git_ps1() { echo " (disabled)"; }'

alias py='/usr/bin/ipython'
alias latexmk='latexmk -interaction=nonstopmode'
alias vims='/usr/bin/vim --servername VIM'
alias tig='/usr/bin/tig --date-order --all'
alias mutt_remilia='/usr/bin/mutt -F /home/remilia/.mutt/remilia@koumakan.cc/muttrc'

# tool
set_title() {
    echo -en "\e]0;$@\a"
}
