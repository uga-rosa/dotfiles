# windows_commands
export PATH=$HOME/.windows_command:$PATH

# afx (package manager for zsh)
export AFX_COMMAND_PATH="$HOME/.afx/bin"
export PATH="$AFX_COMMAND_PATH:$PATH"

# Path to my local dir
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Go
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Node
export PATH=$PATH:./node_modules/.bin

# deno
export PATH="$PATH:$HOME/.deno/bin"
export DENO_INSTALL="$HOME/.deno"

# Nim
export PATH="$HOME/.nimble/bin:$PATH"

# X server
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# Cuda
export PATH="/usr/local/cuda/bin:$PATH"
