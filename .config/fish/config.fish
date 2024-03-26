fish_add_path $HOME/.local/bin

# aqua
fish_add_path (aqua root-dir)/bin

# tools
## mise
mise activate fish | source
## gomi
abbr -a rr gomi
## fzf
set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x FZF_DEFAULT_OPTS '--height 50% --reverse'
set -x FZF_CTRL_T_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set -x FZF_CTRL_T_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'
set -x FZF_ALT_C_COMMAND 'fd --type d'
## zoxide
zoxide init fish | source
set -x _ZO_FZF_OPTS '--no-sort --height 45% --reverse'
## eza
abbr -a l   eza --icons
abbr -a la  eza -a --icons
abbr -a ll  eza -aal --icons
abbr -a lt  'eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
abbr -a lta 'eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
## lazygit
abbr -a g lazygit

# ENVIRONMENT VARIABLES
## deno
set -x DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin

## Rust
fish_add_path $HOME/.cargo/bin

## Go
set -x GOPATH $HOME/.go
fish_add_path $GOPATH/bin
fish_add_path /usr/local/go/bin

# abbrev
## Git
abbr -a gco git checkout
## Neovim
abbr -a nv nvim

if status is-interactive
  # Vim key bindings and emacs key bindings Insert-Mode
  fish_hybrid_key_bindings
end
