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

# python
alias python='python3.10'
alias pip='pip3.10'

# rust
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# go
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# deno
export PATH="$PATH:$HOME/.deno/bin"
export DENO_INSTALL="$HOME/.deno"

# gromacs
[[ -f /usr/local/gromacs/bin/GMXRC ]] && source /usr/local/gromacs/bin/GMXRC
