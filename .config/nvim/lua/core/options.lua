local augroup = vim_api.augroup
local fn = vim.fn

vim.opt.fileencoding = "utf-8"
vim.opt.hidden = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.scrolloff = 3
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 25
vim.opt.termguicolors = true
vim.opt.foldenable = false
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes"
vim.opt.dictionary = "/usr/share/dict/words"
-- vim.opt.dictionary = "~/dotfiles/doc/vim_dictionary"

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
if pcall(require, "filetype") then
    vim.g.did_load_filetypes = 1
end

augroup({
    zenhan = {
        "InsertLeave",
        "*",
        "call system('zenhan.exe 0')",
    },
    quit_help = {
        "FileType",
        "help,qf",
        "nnoremap <buffer><nowait> q <cmd>quit<cr>",
    },
    automkdir = {
        "BufWritePre",
        "*",
        function()
            local dir = fn.expand("%:p:h")
            if fn.isdirectory(dir) == 0 then
                fn.mkdir(dir, "p")
            end
        end,
    },
    better_escape = {
        { "InsertCharPre", "*", 'lua require("core.escape").escape()' },
        { "InsertLeave", "*", 'lua require("core.escape").leave()' },
    },
    mypacker = { "BufWrite", "*list.lua", "PackerCompile" },
    lua_run = { "FileType", "lua", "nnoremap <buffer> @R <cmd>w<cr><cmd>luafile %<cr>" },
})
