#!/bin/bash
set -eu

sudo apt install luajit

# luarocks
# Prerequisite
sudo apt install build-essential libreadline-dev unzip
# Download and Install
VERSION="3.9.1"
TAR_NAME="v$VERSION.tar.gz"
DIR="luarocks-$VERSION"
wget "https://github.com/luarocks/luarocks/archive/refs/tags/$TAR_NAME"
tar xvf "$TAR_NAME"
rm "$TAR_NAME"
cd "$DIR"
mkdir -p "$HOME/.luarocks"
./configure \
  --rocks-tree="$HOME/.luarocks" \
  --lua-version=5.1
make
sudo make install
cd ..
rm -rf "$DIR"
