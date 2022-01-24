# antibody
if [[ ! -e ~/.local/bin/antibody ]]; then
    curl -sfL git.io/antibody | sh -s - -b ~/.local/bin
fi

_antibody_update() {
    antibody bundle > ~/.zsh_plugin.sh << EOL
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions
woefe/git-prompt.zsh
mafredri/zsh-async
sindresorhus/pure
EOL
    source ~/.zsh_plugin.sh
    echo 'updated'
}

antibody() {
    if [[ $1 == "update" ]]; then
        _antibody_update
    else
        ~/.local/bin/antibody $@
    fi
}

if [[ -e ~/.zsh_plugin.sh ]]; then
    source ~/.zsh_plugin.sh
else
    antibody update
fi

# theme
autoload -U promptinit; promptinit
zstyle ':prompt:pure:prompt:success' color green
zstyle ':prompt:pure:git:branch' color '#ae81ff'
prompt pure

# completion config
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

# key binding
bindkey -v

bindkey -M viins '^F' forward-char
bindkey -M viins '^B' backward-char
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^D' delete-char

bindkey -r "^G"

# unbind C-S/Q
stty stop undef
stty start undef

export EDITOR=nvim
export TERM=xterm-256color
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt AUTO_PARAM_KEYS

# nvim alias
alias nv="nvim"

# lazygit
alias g="lazygit"

# cd git root
function g-root() {
    if [[ $(git rev-parse --is-inside-work-tree) ]]; then
        cd $(git rev-parse --show-toplevel)
    fi
}

# fzf
## automatically install
if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

## config
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 50% --reverse'
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export FZF_ALT_C_COMMAND='fd --type d'

## upgrade function
function fzf-upgrade() {
    cd ~/.fzf
    git pull
    ./install --all
    cd -
}

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

# pyenv
source "$HOME/.zsh.d/lazyenv.sh"
_pyenv_init() {
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
}
eval "$(lazyenv.load _pyenv_init pyenv python pip)"

# zoxide
eval "$(zoxide init zsh)"

# windows chrome
function chrome() {
    if [[ -z $1 ]]; then
        chrome.exe
    else
        chrome.exe $(wslpath -w ${1})
    fi
}

# pandoc
function md2pptx() {
    if [[ -z $1 ]]; then
        1
    else
        pandoc -s $1 -o ${1%.*}.pptx --reference-doc="/home/uga/slide/theme/reference.pptx"
    fi
}

# tmux
export TERM="tmux-256color"

# tmux-session-select
function tmux_session_select() {
    ID=$(tmux list-sessions 2>&1)
    if [[ -z $TMUX ]]; then
        create_new_session="Create New Session"
        ID="$ID\n"
    else
        create_new_session=""
    fi
    if [[ $ID =~ 'no server running on' ]]; then
        ID=""
    fi
    ID=$ID$create_new_session:
    selected=$(echo "$ID" | fzf | cut -d: -f1)
    if [[ -n $selected && $selected == $create_new_session ]]; then
        BUFFER="tmux new-session"
        zle accept-line
    elif [[ -n $selected ]]; then
        if [[ -n $TMUX ]]; then
            BUFFER="tmux switch -t $selected"
        else
            BUFFER="tmux attach-session -t $selected"
        fi
        zle accept-line
    fi
}
zle -N tmux_session_select
bindkey '^S' tmux_session_select

# gromacs
[[ -f /usr/local/gromacs/bin/GMXRC ]] && source /usr/local/gromacs/bin/GMXRC
