#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# The terminal variable is needed by i3 (in i3-sensible-terminal script).
# By setting the terminal variable, it is launched by $mod + Enter combination
TERMINAL=xterm

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotgit='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

source /usr/share/git/completion/git-prompt.sh

#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
PS1='\W $(__git_ps1 "git:(%s)")  '

