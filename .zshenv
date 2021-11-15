# unique path
typeset -U path PATH

export LIBGL_ALWAYS_INDIRECT=1

# brew
[[ -d /home/linuxbrew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# rust
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# windows_commands
export PATH=$HOME/.windows_command:$PATH

# Path to mine
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# X server
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# go
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# nim
export PATH="$PATH:$HOME/.nimble/bin"

# julia
export PATH="$PATH:$HOME/.local/julia/bin"
