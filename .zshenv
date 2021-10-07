# unique path
typeset -U path PATH

export LIBGL_ALWAYS_INDIRECT=1

# brew
[[ -d /home/linuxbrew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# rust
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# windows_commands
export PATH=$HOME/.windows_command:$PATH

# Path to mine
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# X server
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# go
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# nim
export PATH="$PATH:$HOME/.nimble/bin"

# lua
eval $(luarocks path)
mylua="$HOME/lua/5.4/share/?.lua;$HOME/lua/5.4/share/?/init.lua"
[[ ! $LUA_PATH == *$mylua ]] && export LUA_PATH="$LUA_PATH;$mylua"
