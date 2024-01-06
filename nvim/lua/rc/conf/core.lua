require("rc.conf.options")
require("rc.conf.mappings")
require("rc.conf.uga")
require("rc.conf.ftdetect")
require("rc.conf.lsp")
require("rc.conf.oscyank")

if uga.fs.isfile("~/.secret/key.vim") then
  vim.cmd.source("~/.secret/key.vim")
end
