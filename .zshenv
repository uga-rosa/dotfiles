# windows_commands
export PATH="$HOME/.windows_command:$PATH"

# afx (package manager for zsh)
export AFX_COMMAND_PATH="$HOME/.afx/bin"
export PATH="$AFX_COMMAND_PATH:$PATH"

# Path to my local dir
export PATH="$HOME/.local/bin:$PATH"

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Language must be set be en_US
export LANGUAGE="en_US.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

# Rust
[[ -f "$HOME/.cargo/env" ]] && source ~/.cargo/env

# Go
export GOPATH="$HOME/.go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

# Node
export PATH="./node_modules/.bin:$PATH"

# deno
export PATH="$HOME/.deno/bin:$PATH"
export DENO_INSTALL="$HOME/.deno"

# Nim
export PATH="$HOME/.nimble/bin:$PATH"

# Cuda
export CUDA_HOME="/usr/local/cuda"
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# themis
alias themis="$HOME/.local/share/vim-themis/bin/themis"
export THEMIS_VIM="nvim"

# denops test
export DENOPS_TEST_DENOPS_PATH="$HOME/.local/share/nvim/lazy/denops.vim"
export DENOPS_TEST_VIM=$(command -v vim)
export DENOPS_TEST_NVIM=$(command -v nvim)
