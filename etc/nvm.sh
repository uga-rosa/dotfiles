#!/bin/bash

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source "${HOME}/.zshenv"
nvm install --lts --latest-npm
source "${HOME}/.zshenv"

package=(
  neovim
  yarn
  @marp-team/marp-cli
)

for p in ${package}; do
  npm install -g "${p}"
done
