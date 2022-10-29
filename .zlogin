# Editor
export EDITOR=nvim
alias nv="nvim"
alias v="nvim"
alias nvr="$HOME/neovim_release/bin/nvim"

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

# check if alias after sudo
# alias sudo='sudo '
alias rm="rm -i"

# Go to home of Windows (for WSL)
if [[ -d /mnt/e/home ]]; then
    export WIN_HOME="/mnt/e/home"
elif [[ -d /mnt/c/Users/uga ]]; then
    export WIN_HOME="/mnt/c/Users/uga"
fi
home() {
    if [[ -n "$WIN_HOME" ]]; then
        cd "$WIN_HOME"
    else
        cd "$HOME"
    fi
}

# browser
vivaldi="/mnt/c/Users/uga/AppData/Local/Vivaldi/Application/vivaldi.exe"
chrome="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
if [[ -f $vivaldi ]]; then
    export BROWSER="$vivaldi"
elif [[ -f $chrome ]]; then
    export BROWSER="$chrome"
fi

browser() {
    if [[ -z $1 ]]; then
        $BROWSER
    elif [[ -f $1 ]]; then
        $BROWSER $(wslpath -w ${1})
    else
        $BROWSER $1
    fi
}

# zenn start
zs() {
    npx zenn preview&
    "$BROWSER" 'http://localhost:8000'
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
