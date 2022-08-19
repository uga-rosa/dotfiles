#!/bin/bash
set -eu

VERSION="3.10.6"

# Use pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Python build dependencies
sudo apt update
sudo apt install make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# install
pyenv install $VERSION
pyenv global $VERSION
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
pip install --upgrade pip
pip install numpy scipy matplotlib neovim

echo 'Run `relogin`!'
