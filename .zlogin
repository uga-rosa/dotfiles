# Editor
export EDITOR=nvim
alias nv="nvim"
alias v="nvim"
alias nvr="/usr/local/nvim-v0.8.0/bin/nvim"

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
