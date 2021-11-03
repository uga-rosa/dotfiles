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
