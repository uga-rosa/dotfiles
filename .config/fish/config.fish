set -x PATH $HOME/.local/bin:$PATH

# mise
mise activate fish | source

# deno
set -x DENO_INSTALL $HOME/.deno
set -x PATH $DENO_INSTALL/bin:$PATH

# Rust
set -x PATH $HOME/.cargo/bin

# Go
set -x GOPATH $HOME/.go/bin
set -x PATH /usr/local/go/bin:$GOPATH/bin:$PATH

# abbrev
## Git
abbr --add gco git checkout
## Neovim
abbr --add nv nvim

if status is-interactive
  # Vim key bindings and emacs key bindings Insert-Mode
  fish_hybrid_key_bindings
end
