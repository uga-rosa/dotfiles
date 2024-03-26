# afx
set -x AFX_COMMAND_PATH $HOME/.afx/bin
set -x PATH $AFX_COMMAND_PATH:$PATH

# deno
set -x DENO_INSTALL $HOME/.deno
set -x PATH $DENO_INSTALL/bin:$PATH

# abbrev
## Git
abbr --add gco git checkout
## Neovim
abbr --add nv nvim

if status is-interactive
  # afx
  afx init | source

  # Vim key bindings and emacs key bindings Insert-Mode
  fish_hybrid_key_bindings
end
