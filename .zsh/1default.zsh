# sudo -e
export EDITOR=nvim

# 履歴保存管理
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space

# 他のzshと履歴を共有
setopt inc_append_history
setopt share_history

# 環境変数を補完
setopt AUTO_PARAM_KEYS

# nvim alias
alias nv="nvim"

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

# git
alias g="lazygit"

# cd git root
function g-root() {
if [[ $(git rev-parse --is-inside-work-tree) ]]; then
  cd $(git rev-parse --show-toplevel)
fi
}
