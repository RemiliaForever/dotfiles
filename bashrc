#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export STEAM_RUNTIME=0
export JAVA_HOME=/usr/lib/jvm/default
export GOPATH=/home/remilia/Workspace/GoTest
#export MESA_GL_VERSION_OVERRIDE=2.1
source /usr/share/git/completion/git-completion.bash
source /usr/share/doc/pkgfile/command-not-found.bash
source ~/.git-prompt.sh

export PS1='\[\e[34m\]┌\[\e[32m\]\u\[\e[35m\]@\[\e[32m\]\H \[\e[35m\]\A \[\e[33m\]\w\[\e[0m\]$(echo -e "$(__git_ps1)") $DEF_PROXY\n\[\e[34m\]└\[\e[35m\]\$\[\e[0m\] '

export PAGER='less'
export EDITOR='vim'
export BROWSER='chromium'

alias ls='ls --color=always'
alias grep='grep --color=always'

alias exeg++='x86_64-w64-mingw32-g++'
alias exegcc='x86_64-w64-mingw32-gcc'
alias execmake='x86_64-w64-mingw32-cmake'

alias aria2c='aria2c --conf-path=/home/remilia/.config/aria2c/daemon'
alias gpg='gpg --keyserver pgp.mit.edu'
alias ssp='source setproxy.sh'
alias ygt='you-get -p mpv'
alias bmpv='/usr/local/bin/xwinwrap -ni -fs -s -st -sp -b -nf -ov -- mpv -wid WID'
