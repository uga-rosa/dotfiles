# unique path
typeset -U path PATH

export LIBGL_ALWAYS_INDIRECT=1

# brew
[[ -d /home/linuxbrew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# windows_commands
export PATH=$HOME/.windows_command:$PATH

# Path to mine
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
