#
# ~/.bash_profile
#

. .bashrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
