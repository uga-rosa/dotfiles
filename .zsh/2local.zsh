export weeklyreport="$HOME/workspace/slide/Weekly_report"
export workspace="$HOME/workspace"
export ehome="/mnt/e/home"
alias wr="cd $weeklyreport"
alias home="cd $ehome"

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

export CHROME_PATH=$(which google-chrome)

export TERM=xterm-256color

alias google-chrome="google-chrome --enable-features=WebUIDarkMode --force-dark-mode"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 50% --reverse'
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export FZF_ALT_C_COMMAND='fd --type d'

# zoxide
eval "$(zoxide init zsh)"

# pyenv
eval "$(pyenv init -)"

# lazygit
alias g="lazygit"

# windows chrome
function wchrome() {
  [[ -z ${1} ]] && return 1
  chrome.exe $(wslpath -w ${1})
}

# tmux-session-select
if [ -n $SSH_TTY ]; then
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
fi
