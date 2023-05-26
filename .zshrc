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

# Completion
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

# Editor
export EDITOR=nvim
alias nv="nvim"

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

# safely remove
alias rm="rm -i"

alias relogin='exec $SHELL -l'

# rtx activate zsh {{{
export PATH="/home/uga/.afx/github.com/jdxcode/rtx/rtx/bin:$PATH"
export RTX_SHELL=zsh

rtx() {
  local command
  command="${1:-}"
  if [ "$#" = 0 ]; then
    command rtx
    return
  fi
  shift

  case "$command" in
  deactivate|shell)
    eval "$(command rtx "$command" "$@")"
    ;;
  *)
    command rtx "$command" "$@"
    ;;
  esac
}

_rtx_hook() {
  eval "$(rtx hook-env -s zsh)";
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_rtx_hook]+1}" ]]; then
  precmd_functions=( _rtx_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_rtx_hook]+1}" ]]; then
  chpwd_functions=( _rtx_hook ${chpwd_functions[@]} )
fi
#}}}
