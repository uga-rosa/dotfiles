#!/bin/bash
set -eu

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
rm go1.19.linux-amd64.tar.gz
