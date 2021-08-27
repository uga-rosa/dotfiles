local augroup = utils.augroup

vim.o.fileencoding = "utf-8"
vim.o.hidden = true
vim.o.title = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmatch = true
vim.o.cursorline = false
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = false
vim.o.showcmd = true
vim.o.scrolloff = 3
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.inccommand = "split"
vim.o.signcolumn = "yes"
vim.o.shell = "/bin/zsh"

augroup("nocomment", { { "BufEnter", "*", "setlocal formatoptions-=ro" } })

augroup("quit_help", { { "FileType", "help", "nnoremap <nowait><buffer> q <cmd>q<cr>" } })

augroup("indent4", {
  { "FileType", "python", "setlocal tabstop=4" },
  { "FileType", "python", "setlocal shiftwidth=4" },
})

augroup("MyFiletype", { { "BufEnter", "*.inp", "set filetype=packmol" } })

augroup("RemoveTrailingWhitespace", {
  {
    "BufWrite",
    "*",
    function()
      if vim.bo.filetype ~= "markdown" then
        vim.cmd([[%s/ \+$//e]])
      end
    end,
  },
})
