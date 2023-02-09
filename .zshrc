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

# Gromacs 2022.4
gromacs="/usr/local/gromacs-2022.4/bin/GMXRC"
[ -f $gromacs ] && source "$gromacs"
