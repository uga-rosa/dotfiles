" This configuration does not take into account anything other than
" neovim in unix.

lua <<EOL
if vim.loader then
  -- v0.9.0 doesn't have vim.loader yet.
  vim.loader.enable()
end
require("rc.conf.options")
require("rc.conf.mappings")
require("rc.conf.ftdetect")
require("rc.conf.vim")
require("rc.conf.lsp")
EOL

if filereadable(expand('~/.secret.vim'))
  source ~/.secret.vim
endif

execute 'source' stdpath('config') . '/dein.vim'
