# key binding
bindkey -v

bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^F' forward-char
bindkey -M viins '^B' backward-char
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^D' delete-char

bindkey -r "^G"

# unbind C-S/Q
stty stop undef
stty start undef

export EDITOR=nvim
export TERM=xterm-256color
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt AUTO_PARAM_KEYS

# nvim alias
alias nv="nvim"

# stack
alias ghci="stack ghci"

# lazygit
alias g="lazygit"

# cd git root
function g-root() {
if [[ $(git rev-parse --is-inside-work-tree) ]]; then
  cd $(git rev-parse --show-toplevel)
fi
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 50% --reverse'
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export FZF_ALT_C_COMMAND='fd --type d'

function fzf-upgrade() {
cd ~/.fzf
git pull
./install --all
cd -
}

# exa
if [[ $(command -v exa) ]]; then
  alias e='exa --icons'
  alias l=e
  alias ls=e
  alias ea='exa -a --icons'
  alias la=ea
  alias ee='exa -aal --icons'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
fi

# zoxide
eval "$(zoxide init zsh)"

# pyenv
eval "$(pyenv init -)"

# starship
eval "$(starship init zsh)"

# windows chrome
function chrome() {
  if [[ -z $1 ]]; then
    chrome.exe
  else
    chrome.exe $(wslpath -w ${1})
  fi
}

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

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-rust \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-bin-gem-node

## End of Zinit's installer chunk

# for zoxide
unalias zi

zinit light zsh-users/zsh-syntax-highlighting

zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-completions

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:default' menu select=1

# gromacs
[[ -f /usr/local/gromacs/bin/GMXRC ]] && source /usr/local/gromacs/bin/GMXRC
