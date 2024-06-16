#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Using 1 as the first number is supposed to give the lighter version of the
# color. It also makes it bold, and using the bold ANSI code with the darker
# version just makes the lighter one
BOLD='\e[1m'

RED='\[\e[1;31m\]'
GREEN='\[\e[1;32m\]'
BLUE='\[\e[1;34m\]'
PURPLE='\[\e[1;35m\]'
CYAN='\[\e[1;36m\]'

STOP_COLOR='\[\e[0m\]'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotgit='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

if [ -n "$WSL_DISTRO_NAME" ]; then
    source ~/.bashrc_wsl
else
    # The terminal variable is needed by i3 (in i3-sensible-terminal script).
    # By setting the terminal variable, it is launched by $mod + Enter
    # combination
    TERMINAL=xterm

    source /usr/share/git/completion/git-prompt.sh
    # Set the PS1 prompt
    PS1="${PURPLE}\W ${STOP_COLOR}\$(__git_ps1 '${BLUE}git:(${STOP_COLOR}${RED}%s${STOP_COLOR}${BLUE})')${STOP_COLOR} ${PURPLE}${STOP_COLOR} "
fi

