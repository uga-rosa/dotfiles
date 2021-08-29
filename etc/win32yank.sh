#!/bin/zsh

set -eu
curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
rm /tmp/win32yank.zip
chmod +x /tmp/win32yank.exe
mv /tmp/win32yank.exe ~/.local/bin
