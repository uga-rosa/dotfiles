#!/bin/zsh

mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/nvim https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage
chmod +x ~/.local/bin/nvim
