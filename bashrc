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
alias ls='/usr/bin/eza --icons=auto'
alias ll='/usr/bin/eza -bghHliS --icons=auto'
alias grep='/usr/bin/rg'
alias ncdu='/usr/bin/ncdu --color=dark'
alias ping='/usr/bin/prettyping'
alias cat='/usr/bin/bat'
alias diff='delta'
# bat
export BAT_PAGER="less -RF"
export BAT_THEME=OneHalfDark
# fzf
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'enter:become(vim {})'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --color header:italic"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
# extend utils
source ~/.ranger-cd.sh
for c in $(ls ~/.local/share/bash-completion/*); do
    source $c
done


alias ssp='source setproxy.sh'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'

alias engit='source ~/.git-prompt.sh'
alias disgit='__git_ps1() { echo " (disabled)"; }'
alias enrustup='export PATH=/home/remilia/.rustup/bin:$PATH'
alias disrustup='export PATH=${PATH#/home/remilia/.rustup/bin:}'

alias py='/usr/bin/ipython'
alias latexmk='latexmk -interaction=nonstopmode'
alias vims='/usr/bin/vim --servername VIM'
alias tig='/usr/bin/tig --date-order --all'
alias mutt_remilia='/usr/bin/mutt -F /home/remilia/.mutt/remilia@koumakan.cc/muttrc'

# tool
set_title() {
    echo -en "\e]0;$@\a"
}
