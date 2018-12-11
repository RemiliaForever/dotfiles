#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
#export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export DOCKER_HOST=tcp://node0:2375

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
