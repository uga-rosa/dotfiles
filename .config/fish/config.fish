fish_add_path $HOME/.local/bin

# afx
set -x AFX_COMMAND_PATH $HOME/.afx/bin
fish_add_path $AFX_COMMAND_PATH
afx init | source

# mise
mise activate fish | source

# ENVIRONMENT VARIABLES
## deno
set -x DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin

## Rust
fish_add_path $HOME/.cargo/bin

## Go
set -x GOPATH $HOME/.go
fish_add_path $GOPATH/bin
fish_add_path /usr/local/go/bin

# abbrev
## Git
abbr --add gco git checkout
## Neovim
abbr --add nv nvim

if status is-interactive
  # Vim key bindings and emacs key bindings Insert-Mode
  fish_hybrid_key_bindings
end
