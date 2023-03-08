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
export PATH=$PATH:./node_modules/.bin

# deno
export PATH="$PATH:$HOME/.deno/bin"
export DENO_INSTALL="$HOME/.deno"

# Nim
export PATH="$HOME/.nimble/bin:$PATH"

# Cuda
export CUDA_HOME="/usr/local/cuda"
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

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

# themis
themis_bin="$HOME/.cache/dein/repos/github.com/thinca/vim-themis/bin"
if [[ -d $themis_bin ]]; then
    export PATH="$PATH:$themis_bin"
    export THEMIS_VIM="nvim"
fi
