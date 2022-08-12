#!/bin/bash
set -eu

# It should be included by default, so it is basically unnecessary.
# sudo apt install aspell aspell-en

mkdir -p ~/.dict
aspell -d en dump master | aspell -l en expand > ~/.dict/en.dict
