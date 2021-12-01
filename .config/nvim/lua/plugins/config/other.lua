local M = {}

local map = vim_api.map

M.luatab = function()
    require("luatab").setup({})
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

M.lazygit = function()
    vim.g.lazygit_floating_window_use_plenary = true
    map("n", "<leader>l", "LazyGit", "cmd")
end

M.easyalign = function()
    map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
end

M.operator_replace = function()
    map("n", "q", "<Plug>(operator-replace)")
end

M.textobj = function()
    vim.fn["textobj#user#plugin"]("formula", {
        ["dollar-a"] = {
            pattern = [[\$.\{-}\$]],
            select = { "a$" },
        },
        ["dollar-i"] = {
            pattern = [[\$\zs.\{-}\ze\$]],
            select = { "i$" },
        },
    })
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

function M.translate()
    vim.cmd("command! -range TransJa2En TranslateF ja en")
    vim.cmd("command! -range TransEn2Ja TranslateF en ja")
    vim_api.augroup({ translate = { "CursorMoved", "*", "TranslateClose" } })
end

return M
