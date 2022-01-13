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

map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader><cr>", "o<Esc>")

map("n", "Q", "q")

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

map("n", "Y", "y$")

map("n", "x", '"_x')
map("n", "s", '"_s')

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")

map("n", "j", "gj")
map("n", "gj", "j")
map("n", "k", "gk")
map("n", "gk", "k")

map("i", "<C-f>", "<C-g>U<Right>")
map("c", "<C-f>", "<Right>")
map("i", "<C-b>", "<C-g>U<Left>")
map("c", "<C-b>", "<Left>")
map({ "i", "c" }, "<C-d>", "<Del>")
map({ "i", "c" }, "<C-h>", "<BS>", { remap = true })
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<C-x>", [[expand('%:p')]], "expr")

map("i", "<C-g>", "<C-d>")

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
