pcall(require, "impatient")

vim.cmd([[
if filereadable(expand('~/.secret.vim'))
    source ~/.secret.vim
endif
let g:vsctm_extensions_path = expand('~/extensions')
set runtimepath^=~/plugin/dps-vsctm.vim
]])

require("utils")
require("rc.option")
require("rc.autocmd")
require("rc.mapping")
require("rc.ftdetect")
-- init.lua is sourced after ftplugin/*
require("rc.ftplugin")
-- plugin
require("rc.jetpack")
