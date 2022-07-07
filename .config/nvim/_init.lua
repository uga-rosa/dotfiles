local env = vim.env
local opt = vim.opt
local cmd = vim.cmd
local fn  = vim.fn

local config_directory = env.XDG_CONFIG_HOME
opt.packpath:append(config_directory .. '/nvim/pack')

cmd([[
packloadall
filetype plugin indent on
]])

local cmp = require('cmp')

cmp.setup {
	sources = {
		{
			name = "dictionary",
			keyword_length = 1,
		},
	},
}

local cmp_dictionary = require("cmp_dictionary")

local dictionary_directories = env.HOME .. '/.usr/share/dict/' .. ',' .. '/usr/share/dict/'
local dictionary_files = fn.globpath(dictionary_directories, '*', 0, 1)

cmp_dictionary.setup({
	dic = {
		["*"] = dictionary_files,
	},
	exact = -1,
	first_case_insensitive = false,
	document = false,
	document_command = "wn %s -over",
	async = true,
	capacity = 10,
	debug = false,
})
