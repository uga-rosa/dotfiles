# windows_commands
export PATH="$HOME/.windows_command:$PATH"

# afx (package manager for zsh)
export AFX_COMMAND_PATH="$HOME/.afx/bin"
export PATH="$AFX_COMMAND_PATH:$PATH"

# Path to my local dir
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Language must be set be en_US
export LANGUAGE="en_US.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

# Pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Rust
[[ -f "$HOME/.cargo/env" ]] && source ~/.cargo/env

# Go
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Node
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

# deno
export PATH="$PATH:$HOME/.deno/bin"
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
