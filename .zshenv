# Autoload
autoload -U compinit; compinit

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

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

# Language must be set be en_US
export LANGUAGE="en_US.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

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

# Cuda
export PATH="/usr/local/cuda/bin:$PATH"

# gmxenv
export PATH="$HOME/.gmxenv/bin:$PATH"
export PATH="$HOME/.gmxenv/shims:$PATH"

# browser
vivaldi="/mnt/c/Users/uga/AppData/Local/Vivaldi/Application/vivaldi.exe"
chrome="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
if [[ -f $vivaldi ]]; then
    export BROWSER="$vivaldi"
elif [[ -f $chrome ]]; then
    export BROWSER="$chrome"
fi

browser() {
    if [[ -z $1 ]]; then
        $BROWSER
    elif [[ -f $1 ]]; then
        $BROWSER $(wslpath -w ${1})
    else
        $BROWSER $1
    fi
}

# Mason's tool
mason_bin="$HOME/.local/share/nvim/mason/bin"
if [[ -d $mason_bin ]]; then
    export PATH="$mason_bin:$PATH"
fi
