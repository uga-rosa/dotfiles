local fn = vim.fn
local map = vim_api.map
local map_conv = vim_api.map_conv

vim.g.mapleader = " "

map("n", "O", function(fallback)
    vim.cmd("normal zz")
    fallback()
end)

map("n", "o", function(fallback)
    vim.cmd("normal zz")
    fallback()
end)

map("n", "<M-h>", function()
    vim.cmd("h " .. fn.expand("<cword>"))
end)

map("n", "<M-k>", "EiwaPopup", "cmd")

map("n", "<esc><esc>", "nohlsearch", { "noremap", "cmd" })
map("n", "<leader><cr>", "o<esc>", "noremap")

map("n", "Q", "q", "noremap")

map("v", "<", "<gv", "noremap")
map("v", ">", ">gv", "noremap")

map("n", "+", "<C-a>", "noremap")
map("n", "-", "<C-x>", "noremap")

map("n", "Y", "y$", "noremap")

map("n", "x", '"_x', "noremap")
map("n", "s", '"_s', "noremap")

map({ "n", "x", "o" }, "H", "^", "noremap")
map({ "n", "x", "o" }, "L", "$", "noremap")

map_conv("n", "j", "gj", "noremap")
map_conv("n", "k", "gk", "noremap")

map({ "i", "c" }, "<C-f>", "<right>", "noremap")
map({ "i", "c" }, "<C-b>", "<left>", "noremap")
map({ "i", "c" }, "<C-d>", "<delete>", "noremap")
map("c", "<C-a>", "<home>", "noremap")
map("c", "<C-e>", "<end>", "noremap")
map("c", "<C-x>", [[expand('%:p')]], { "noremap", "expr" })

map("i", "<C-g>", "<C-d>", "noremap")

-- packer.nvim
vim.cmd([[
silent! command PackerCompile lua require('plugins.list') require('packer').compile()
silent! command PackerInstall lua require('plugins.list') require('packer').install()
silent! command PackerStatus lua require('plugins.list') require('packer').status()
silent! command PackerUpdate lua require('plugins.list') require('packer').update()
silent! command PackerSync lua require('plugins.list') require('packer').sync()
]])

map("n", "<leader>ps", function()
    local filename = vim.fn.expand("%:p")
    if filename ~= "" then
        vim.cmd("w")
    end
    if filename == "list.lua" then
        vim.cmd("so %")
    end
    require("plugins.list")
    require("packer").sync()
end)
