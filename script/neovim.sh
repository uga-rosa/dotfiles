#!/bin/bash
set -eu

# Build prerequisites
# sudo apt update
# sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# build
neovim_dir="$HOME/.neovim"
if [[ -d $neovim_dir ]]; then
  cd "$neovim_dir"
  git pull
else
  git clone https://github.com/neovim/neovim "$neovim_dir"
  cd "$neovim_dir"
fi
make CMAKE_BUILD_TYPE=Release
sudo make install
