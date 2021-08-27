# よく行くdirectory
export weeklyreport="$HOME/workspace/slide/Weekly_report"
export workspace="$HOME/workspace"
export ehome="/mnt/e/home"
alias wr="cd $weeklyreport"
alias home="cd $ehome"

# Xserver
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# marp
export CHROME_PATH=$(which google-chrome)

# tmux
export TERM=xterm-256color

# trash-cli
alias mm="trash-put"

# chrome
alias google-chrome="google-chrome --enable-features=WebUIDarkMode --force-dark-mode"

# windows chrome
function wchrome() {
  [[ -z ${1} ]] && return 1
  chrome.exe $(wslpath -w ${1})
}

# scpの帯域制限
alias scp="scp -l 163840"

# tmux-session-select
function tmux_session_select() {
  ID=$(tmux list-sessions)
  if [[ -z $ID ]]; then
    BUFFER="tmux new-session"
    zle accept-line
  fi
  if [[ -z $TMUX ]]; then
    create_new_session="\nCreate New Session"
  else
    create_new_session=""
  fi
  ID=$ID${create_new_session}:
  ID=$(echo "$ID" | fzf | cut -d: -f1)
  if [[ "\n$ID" == "${create_new_session}" ]]; then
    BUFFER="tmux new-session"
    zle accept-line
  elif [[ -n $ID ]]; then
    in_out="switch"
    [[ -z $TMUX ]] && in_out="attach-session"
    BUFFER="tmux $in_out -t $ID"
    zle accept-line
  else
    :
  fi
}
zle -N tmux_session_select
bindkey '^S' tmux_session_select
