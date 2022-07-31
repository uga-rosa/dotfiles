pcall(require, "impatient")

require("utils")
require("rc.option")
require("rc.autocmd")
require("rc.mapping")
require("rc.ftdetect")
-- init.lua is sourced after ftplugin/*
require("rc.ftplugin")
require("rc.packer")
