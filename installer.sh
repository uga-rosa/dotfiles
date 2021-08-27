#!/bin/bash

set -eu

DOTFILES_PATH=$(cd $(dirname $0); pwd)

for i in .??*; do
  [[ $i == ".git" ]] && continue
  [[ $i == ".gitignore" ]] && continue
  [[ $i == ".DS_Store" ]] && continue
  ln -snfv "${DOTFILES_PATH}"/"$i" ~/"$i"
done
