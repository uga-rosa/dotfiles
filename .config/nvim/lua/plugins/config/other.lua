local M = {}

local map = vim_api.map

M.luatab = function()
    vim.o.tabline = "%!v:lua.require'luatab'.tabline()"
    map("n", "<M-1>", "1gt", "noremap")
    map("n", "<M-2>", "2gt", "noremap")
    map("n", "<M-3>", "3gt", "noremap")
    map("n", "<M-4>", "4gt", "noremap")
    map("n", "<M-5>", "5gt", "noremap")
    map("n", "<M-6>", "6gt", "noremap")
    map("n", "<M-7>", "7gt", "noremap")
    map("n", "<M-8>", "8gt", "noremap")
    map("n", "<M-9>", "9gt", "noremap")
    map("n", "<M-p>", "tabprevious", "cmd")
    map("n", "<M-n>", "tabnext", "cmd")
    map("n", "<M-h>", "tabfirst", "cmd")
    map("n", "<M-l>", "tablast", "cmd")
    map("n", "<M-c>", { "w", "tabclose" }, "cmd")
end

M.easyalign = function()
    map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
end

M.operator_replace = function()
    map("n", "_", "<Plug>(operator-replace)")
end

M.openbrowser = function()
    map({ "n", "x" }, "<M-o>", "<Plug>(openbrowser-smart-search)")
    vim.g.openbrowser_browser_commands = {
        { name = "chrome.exe", args = { "{browser}", "{uri}" } },
    }
end

M.sandwich = function()
    vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
end

M.filittle = function()
    require("nvim-web-devicons").set_icon({
        nim = {
            icon = "",
            color = "#ffff00",
            name = "Nim",
        },
    })
end

M.eft = function()
    map({ "n", "x" }, ";", "<Plug>(eft-repeat)")
    map({ "n", "x", "o" }, "f", "<Plug>(eft-f)")
    map({ "n", "x", "o" }, "F", "<Plug>(eft-F)")
    map({ "n", "x", "o" }, "t", "<Plug>(eft-t)")
    map({ "n", "x", "o" }, "T", "<Plug>(eft-T)")
    vim.cmd("let g:eft_index_function = {'all': { -> v:true}}")
end

M.mkdp = function()
    vim.g.mkdp_refresh_slow = 1
    map("n", "<leader>pn", "MarkdownPreview", "cmd")
end

return M
