vim.opt.fileencoding = "utf-8"

vim.opt.updatetime = 100

vim.opt.number = true
vim.opt.signcolumn = "yes"

vim.opt.showmatch = true

-- 2幅スペース
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- 要らん
vim.opt.swapfile = false

vim.opt.scrolloff = 3

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.pumheight = 25

-- true color
vim.opt.termguicolors = true

-- 折り畳みは使わない
vim.opt.foldenable = false

-- :s などのプレビューが出る
vim.opt.inccommand = "split"

-- クリックはrc/mappings.vimで無効化
vim.opt.mouse = "ni"

-- highlight columns after 'textwidth'
vim.opt.colorcolumn = "+1"

-- heirlineで出す
vim.opt.showmode = false
-- ステータスラインを下だけに
vim.opt.laststatus = 3

-- jaxしかないプラグインもある
vim.opt.helplang = { "en", "ja" }

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- vimgrep
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Disable unused provider
vim.g.loaded_python_provider = false
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
