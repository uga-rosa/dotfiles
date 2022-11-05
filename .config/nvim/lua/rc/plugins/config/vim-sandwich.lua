vim.cmd("runtime macros/sandwich/keymap/surround.vim")
vim.fn["operator#sandwich#set"]("add", "char", "skip_space", 1)
