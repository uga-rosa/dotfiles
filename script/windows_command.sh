#!/bin/bash
set -eu

windows_dir="$HOME/.windows_command"

mkdir -p "$windows_dir"
cd "$windows_dir"

# win32yank
windows_username="uga"
windows_home="/mnt/c/Users/$windows_username"
if [[ ! -d $windows_home ]]; then
  echo "Your windows username $windows_username is not available."
  exit 1
fi
win32yank_dir="$windows_home/AppData/Local/win32yank"
mkdir -p "$win32yank_dir"
cd "$win32yank_dir"
wget https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x86.zip
unzip -o win32yank-x86.zip
rm win32yank-x86.zip

cd "$windows_dir"
ln -sf "$win32yank_dir/win32yank.exe" .

# zenhan.exe
zenhan_dir="$windows_home/AppData/Local/zenhan"
mkdir -p "$zenhan_dir"
cd "$zenhan_dir"
wget https://github.com/iuchim/zenhan/releases/download/v0.0.1/zenhan.zip
unzip zenhan.zip
mv zenhan/bin64/zenhan.exe .
rm -rf zenhan.zip zenhan

cd "$windows_dir"
ln -sf "$zenhan_dir/zenhan.exe" .
