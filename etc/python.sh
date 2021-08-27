#!/bin/zsh

set -eu
sudo apt install build-essential libbz2-dev libdb-dev libreadline-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev libsqlite3-dev libssl-dev zlib1g-dev uuid-dev tk-dev
version="3.9.5"
pyenv install ${version}
pyenv global ${version}
pip install -U pip
pip install -r requirements.txt
echo "complete"
