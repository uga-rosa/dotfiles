# edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

# Editor
export EDITOR=nvim
alias nv="nvim"
alias v="nvim"
alias nvr="/usr/local/nvim-v0.8.1/bin/nvim"

# tmux color
export TERM="tmux-256color"

# X server
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# History file and its size
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=100000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt AUTO_PARAM_KEYS

# Safely remove
alias rm="rm -i"

# zenn cli using Deno
alias zenn="deno run -A npm:zenn-cli@latest"

alias relogin='exec $SHELL -l'
