# tmux
if [[ -z $SSH_TTY && -z $TMUX ]]; then
  # get the IDs
  ID=$(tmux list-sessions)
  if [[ -z $ID ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID=$ID"\n${create_new_session}:"
  ID=$(echo "$ID" | fzf | cut -d: -f1)
  if [[ $ID = ${create_new_session} ]]; then
    tmux new-session
  elif [[ -n $ID ]]; then
    tmux attach-session -t $ID
  else
    :  # Start terminal normally
  fi
fi

# cron
if [[ $(service cron status) =~ 'not' ]]; then
  sudo service cron start
fi

# ssh
if [[ $(service ssh status) =~ 'not' ]]; then
  sudo service ssh start
fi
