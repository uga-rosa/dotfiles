local map = utils.keymap.set

local opt = {
    fileencoding = "utf-8",
    updatetime = 100,
    hidden = true,
    number = true,
    showmatch = true,
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,
    swapfile = false,
    scrolloff = 3,
    ignorecase = true,
    smartcase = true,
    pumheight = 25,
    termguicolors = true,
    foldenable = false,
    clipboard = "unnamedplus",
    inccommand = "split",
    signcolumn = "yes",
    mouse = "a",
}

for k, v in pairs(opt) do
    vim.opt[k] = v
end

-- mouse
map("", "<LeftMouse>", "<Nop>")
map("i", "<LeftMouse>", "<Nop>")
map("", "<2-LeftMouse>", "<Nop>")
map("i", "<2-LeftMouse>", "<Nop>")

-- disable unnecessary plugin
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_gtags = 1
vim.g.loaded_gtags_cscope = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

local win32yank = vim.fn.resolve(vim.fn.exepath("win32yank.exe"))
if win32yank then
    local copy = { win32yank, "-i", "--crlf" }
    local paste = { win32yank, "-o", "--lf" }
    vim.g.clipboard = {
        name = "myClipboard",
        copy = {
            ["+"] = copy,
            ["*"] = copy,
        },
        paste = {
            ["+"] = paste,
            ["*"] = paste,
        },
        cache_enabled = true,
    }
end
