pcall(require, "impatient")

vim.cmd([[
if filereadable(expand('~/.secret.vim'))
    source ~/.secret.vim
endif
]])
require("utils")
require("rc.option")
require("rc.autocmd")
require("rc.mapping")
require("rc.ftdetect")
-- init.lua is sourced after ftplugin/*
require("rc.ftplugin")
-- plugin
require("rc.packer")

vim.cmd([[
set runtimepath^=~/plugin/dps-vsctm.vim
]])
