#!/bin/bash
set -eu

# Build prerequisites
# sudo apt update
# sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# build
neovim_dir="$HOME/.neovim"
if [[ -d $neovim_dir ]]; then
  rm -rf $neovim_dir
fi
git clone --depth 1 https://github.com/neovim/neovim $neovim_dir
cd $neovim_dir
make CMAKE_BUILD_TYPE=Release
sudo make install

prefix="/usr/local/share/nvim/runtime/plugin"
if [[ -d $prefix ]]; then
  sudo rm "$prefix/gzip.vim"
  sudo rm "$prefix/matchit.vim"
  sudo rm "$prefix/matchparen.vim"
  sudo rm "$prefix/netrwPlugin.vim"
  sudo rm "$prefix/shada.vim"
  sudo rm "$prefix/spellfile.vim"
  sudo rm "$prefix/tarPlugin.vim"
  sudo rm "$prefix/tohtml.vim"
  sudo rm "$prefix/tutor.vim"
  sudo rm "$prefix/zipPlugin.vim"
fi
