# .zshrc
#   zshenv -> zprofile -> zshrc (current)
#
# | zshenv   : always
# | zprofile : if login shell
# | zshrc    : if interactive shell
# | zlogin   : if login shell, after zshrc
# | zlogout  : if login shell, after logout

source <(afx init)

# Unbind C-S/Q
stty stop undef
stty start undef

# Emacs key binding
bindkey -e
bindkey "^U" backward-kill-line

# tmux-session-select
function tmux_session_select() {
    ID=$(tmux list-sessions 2>&1)
    if [[ -z $TMUX ]]; then
        create_new_session="Create New Session"
        ID="$ID\n"
    else
        create_new_session=""
    fi
    if [[ $ID =~ 'no server running on' ]]; then
        ID=""
    fi
    ID=$ID$create_new_session:
    selected=$(echo "$ID" | fzf | cut -d: -f1)
    if [[ -n $selected && $selected == $create_new_session ]]; then
        BUFFER="tmux new-session"
        zle accept-line
    elif [[ -n $selected ]]; then
        if [[ -n $TMUX ]]; then
            BUFFER="tmux switch -t $selected"
        else
            BUFFER="tmux attach-session -t $selected"
        fi
        zle accept-line
    fi
}
zle -N tmux_session_select
bindkey '^S' tmux_session_select
