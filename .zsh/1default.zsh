# sudo -e
export EDITOR=nvim

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

# cd git root
function g-root() {
if [[ $(git rev-parse --is-inside-work-tree) ]]; then
  cd $(git rev-parse --show-toplevel)
fi
}
