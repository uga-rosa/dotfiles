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
