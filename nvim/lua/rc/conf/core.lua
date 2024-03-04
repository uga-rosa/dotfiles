require("rc.conf.options")
require("rc.conf.mappings")
require("rc.conf.vim")
require("rc.conf.ftdetect")
require("rc.conf.lsp")
require("rc.conf.oscyank")
require("rc.conf.plugin")

if vim.fs.isfile("~/.secret/key.vim") then
  vim.cmd.source("~/.secret/key.vim")
end
