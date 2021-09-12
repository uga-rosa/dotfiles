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

# exa
if [[ $(command -v exa) ]]; then
  alias e='exa --icons'
  alias l=e
  alias ls=e
  alias ea='exa -a --icons'
  alias la=ea
  alias ee='exa -aal --icons'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
fi

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# starship
eval "$(starship init zsh)"

# go
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# nim
export PATH="$PATH:$HOME/.nimble/bin"
