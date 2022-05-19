# Autoload
autoload -U compinit; compinit

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

# Language must be set be en_US
export LANGUAGE="en_US.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

# Editor
export EDITOR=nvim

# tmux color
export TERM="tmux-256color"

# History file and its size
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=100000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt AUTO_PARAM_KEYS

# check if alias after sudo
# alias sudo='sudo '

# nvim alias
alias nv="nvim"

# Go to home of Windows (for WSL)
home() {
    if [[ -d /mnt/e/home ]]; then
        cd /mnt/e/home
    else
        cd "$HOME"
    fi
}

# windows chrome
chrome() {
    if [[ -z $1 ]]; then
        chrome.exe
    else
        chrome.exe $(wslpath -w ${1})
    fi
}

alias relogin='exec $SHELL -l'

# not ssh and out of tmux
if [[ -z $SSH_TTY && -z $TMUX ]]; then
    # cron
    if [[ $(service cron status) =~ 'not' ]]; then
        sudo service cron start
    fi

    # ssh
    if [[ $(service ssh status) =~ 'not' ]]; then
        sudo service ssh start
    fi

    # tmux
    ID=$(tmux list-sessions 2>&1)
    if [[ $ID =~ 'no server running on' ]]; then
        tmux new-session
        return
    fi
    create_new_session="Create New Session"
    ID="$ID\n$create_new_session:"
    ID=$(echo "$ID" | fzf | cut -d: -f1)
    if [[ $ID == $create_new_session ]]; then
        tmux new-session
    elif [[ -n $ID ]]; then
        tmux attach-session -t $ID
    fi
fi
