#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lash'
alias l='ls'
alias tree='tree -C'
alias sudo='sudo -E'

shopt -s autocd

PS1="\[$(tput bold)\]\[\033[38;5;40m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;214m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;40m\][\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;214m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;40m\]][\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\$?\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;40m\]]\[$(tput sgr0)\]"

# Server PS1
#PS1="\[$(tput bold)\]\[\033[38;5;33m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;214m\]\h\[$(tput sgr0)\]\[\033[38;5;33m\][\[$(tput sgr0)\]\[\033[38;5;214m\]\w\[$(tput sgr0)\]\[\033[38;5;33m\]][\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\$?\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;33m\]]\[$(tput sgr0)\]"
