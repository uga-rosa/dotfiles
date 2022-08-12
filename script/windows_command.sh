#!/bin/bash
set -eu

windows_dir="$HOME/.windows_command"

mkdir -p "$windows_dir"
cd "$windows_dir"

# win32yank
wget https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x86.zip
unzip win32yank-x86.zip
rm win32yank-x86.zip LICENSE README.md
chmod +x win32yank.exe
