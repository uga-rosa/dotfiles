local augroup = myutils.augroup
local map = myutils.map

vim.opt.fileencoding = "utf-8"
vim.opt.hidden = true
vim.opt.title = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.scrolloff = 3
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes"
vim.opt.dictionary:append("/usr/share/dict/words")

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- disable unnecessary plugin
vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.did_load_filetypes = 1

augroup({
  myfiletype = {
    { "BufNewFile,BufRead", "*.inp", "se ft=packmol" },
    { "BufNewFile,BufRead", "*.saty,*.satyh", "se ft=satysfi" },
    { "BufNewFile,BufRead", "*.snip", "se ft=snip" },
    { "BufNewFile,BufRead", "*.yaml", "se ft=yaml.ansible" },
  },
  nim = {
    { "FileType", "nim", "setl foldmethod=manual" },
  },
  nocomment = { "BufEnter", "*", "setl formatoptions-=ro" },
  quit_help = {
    "FileType",
    "help,qf",
    function()
      map("n", "q", "quit", { "nowait", "buffer", "cmd" })
    end,
  },
  indent4 = {
    { "FileType", "python", "setl ts=4 sw=4" },
  },
  RemoveTrailingWhitespace = {
    "BufWrite",
    "*",
    function()
      local ft = vim.bo.filetype
      if not (ft == "markdown" or ft == "snip") then
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
