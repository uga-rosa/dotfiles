local augroup = myutils.augroup
local map = myutils.map

vim.o.fileencoding = "utf-8"
vim.o.hidden = true
vim.o.title = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmatch = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.scrolloff = 3
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.inccommand = "split"
vim.o.signcolumn = "yes"
vim.o.shell = "/bin/bash"

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- disable unnecessary plugin
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.netrw_nogx = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

augroup({
  myfiletype = {
    { "BufNewFile,BufRead", "*.inp", "set ft=packmol" },
    { "BufNewFile,BufRead", "*.saty,*.satyh", "set ft=satysfi" },
    { "BufNewFile,BufRead", "*.nim,*.nims,*.nimble", "set ft=nim" },
  },
  nocomment = { "BufEnter", "*", "setlocal formatoptions-=ro" },
  quit_help = {
    "FileType",
    "help",
    function()
      map("n", "q", "quit", { "nowait", "buffer", "cmd" })
    end,
  },
  indent4 = {
    { "FileType", "python", "setlocal tabstop=4" },
    { "FileType", "python", "setlocal shiftwidth=4" },
  },
  RemoveTrailingWhitespace = {
    "BufWrite",
    "*",
    function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd([[%s/ \+$//e]])
      end
    end,
  },
  automkdir = {
    "BufWritePre",
    "*",
    function()
      local dir = vim.fn.expand("%:p:h")
      if vim.fn.isdirectory(dir) then
        vim.fn.mkdir(dir, "p")
      end
    end,
  },
  mypacker = { "BufWrite", "*list.lua", "PackerCompile" },
})
