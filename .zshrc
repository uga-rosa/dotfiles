# emacs key binding
bindkey -e

# unbind C-S/Q
stty stop undef
stty start undef
# unbind C-g
bindkey -r "^G"
# zpty
zmodload zsh/zpty
# unique path
typeset -U path PATH

# 分割ファイルの読み込み
for i (~/.zsh/*) . $i

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-rust \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-bin-gem-node

## End of Zinit's installer chunk

# zoxideと干渉するので
unalias zi

## シンタックスハイライト
zinit light zsh-users/zsh-syntax-highlighting

## 履歴補完
zinit light zsh-users/zsh-autosuggestions

# コマンド補完
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

alias luamake=/home/nakai/.cache/nvimlsp/lua-language-server/3rd/luamake/luamake
