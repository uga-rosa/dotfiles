#!/bin/bash
set -eu

# Install choosenim
curl https://nim-lang.org/choosenim/init.sh -sSf | sh

choosenim stable
