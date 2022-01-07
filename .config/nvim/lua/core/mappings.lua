local map = vim_api.map
local command = vim.api.nvim_add_user_command

vim.g.mapleader = " "

local function feedkey(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

map("n", "O", function()
    vim.cmd("normal zz")
    feedkey("O")
end)

map("n", "o", function()
    vim.cmd("normal zz")
    feedkey("o")
end)

map("n", "<esc><esc>", "<cmd>nohlsearch<cr>", "noremap")
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

map("n", "j", "gj", "noremap")
map("n", "gj", "j", "noremap")
map("n", "k", "gk", "noremap")
map("n", "gk", "k", "noremap")

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
]])

command("PackerSync", function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")
    local readonly = vim.api.nvim_buf_get_option(0, "readonly")
    if bufname ~= "" and buftype == "" and not readonly then
        vim.cmd("w")
    end
    vim.cmd("so " .. vim.fn.stdpath("config") .. "/lua/plugins/list.lua")
    require("plugins.list")
    require("packer").sync()
end, {})
