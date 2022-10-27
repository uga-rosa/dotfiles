pcall(require, "impatient")

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
let g:denops#debug = 1
]])
