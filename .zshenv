# windows_commands
export PATH=$HOME/.windows_command:$PATH

# afx
export AFX_COMMAND_PATH="$HOME/.afx/bin"
export PATH="$AFX_COMMAND_PATH:$PATH"

# Path to my local dir
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# rust
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# go
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# deno
export PATH="$PATH:$HOME/.deno/bin"
export DENO_INSTALL="$HOME/.deno"

# Nim
export PATH="$HOME/.nimble/bin:$PATH"

# gromacs
[[ -f /usr/local/gromacs/bin/GMXRC ]] && source /usr/local/gromacs/bin/GMXRC
