#!/bin/zsh

set -eu

pandoc_link=${1:-https://github.com/jgm/pandoc/releases/download/2.14.0.2/pandoc-2.14.0.2-1-amd64.deb}
crossref_link=${2:-https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.12.0/pandoc-crossref-Linux.tar.xz}
wget ${pandoc_link}
sudo dpkg -i ${pandoc_link##*/}
rm ${pandoc_link##*/}

wget ${crossref_link}
tar -xvf ${crossref_link##*/}
sudo mv pandoc-crossref /usr/local/bin
rm ${crossref_link##*/} pandoc-crossref.1

sudo apt update
sudo apt install texlive-luatex texlive-lang-cjk lmodern texlive-xetex texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra latexmk latexdiff wkhtmltopdf -y

sudo kanji-config-updmap-sys ipaex
