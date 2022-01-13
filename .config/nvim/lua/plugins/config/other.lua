local M = {}

local map = vim_api.map

function M.luatab()
    require("luatab").setup({})
    map("n", "<M-1>", "1gt")
    map("n", "<M-2>", "2gt")
    map("n", "<M-3>", "3gt")
    map("n", "<M-4>", "4gt")
    map("n", "<M-5>", "5gt")
    map("n", "<M-6>", "6gt")
    map("n", "<M-7>", "7gt")
    map("n", "<M-8>", "8gt")
    map("n", "<M-9>", "9gt")
    map("n", "<M-p>", "<cmd>tabprevious<cr>")
    map("n", "<M-n>", "<cmd>tabnext<cr>")
    map("n", "<M-h>", "<cmd>tabfirst<cr>")
    map("n", "<M-l>", "<cmd>tablast<cr>")
    map("n", "<M-c>", "<cmd>w<cr><cmd>tabclose<cr>")
end

function M.lazygit()
    vim.g.lazygit_floating_window_use_plenary = true
    map("n", "<leader>l", "<cmd>LazyGit<cr>")
end

function M.easyalign()
    map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
end

function M.operator_replace()
    map("n", "q", "<Plug>(operator-replace)")
end

function M.textobj()
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

function M.openbrowser()
    map({ "n", "x" }, "<M-o>", "<Plug>(openbrowser-smart-search)")
    vim.g.openbrowser_browser_commands = {
        { name = "chrome.exe", args = { "{browser}", "{uri}" } },
    }
end

function M.sandwich()
    vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
end

function M.filittle()
    require("nvim-web-devicons").set_icon({
        nim = {
            icon = "",
            color = "#ffff00",
            name = "Nim",
        },
    })
end

function M.eft()
    map({ "n", "x" }, ";", "<Plug>(eft-repeat)")
    map({ "n", "x", "o" }, "f", "<Plug>(eft-f)")
    map({ "n", "x", "o" }, "F", "<Plug>(eft-F)")
    map({ "n", "x", "o" }, "t", "<Plug>(eft-t)")
    map({ "n", "x", "o" }, "T", "<Plug>(eft-T)")
    vim.cmd("let g:eft_index_function = {'all': { -> v:true}}")
end

function M.mkdp()
    vim.g.mkdp_refresh_slow = 1
    map("n", "<leader>p", "MarkdownPreview")
end

function M.translate()
    vim.cmd("command! -range TransJa2En TranslateF ja en")
    vim.cmd("command! -range TransEn2Ja TranslateF en ja")
    vim_api.augroup({ translate = { "CursorMoved", "*", "TranslateClose" } })
end

function M.search()
    map({ "n", "x" }, "/", "<cmd>call searchx#start( {'dir': 1 })<cr>")
    map({ "n", "x" }, "?", "<cmd>call searchx#start( {'dir': 0 } )<cr>")
    map({ "n", "x" }, "n", "<cmd>call searchx#next()<cr>")
    map({ "n", "x" }, "N", "<cmd>call searchx#prev()<cr>")
    map("c", "<C-j>", "<cmd>call searchx#next()<cr>")
    map("c", "<C-k>", "<cmd>call searchx#prev()<cr>")
    map({ "n", "c" }, "<C-l>", "<cmd>call searchx#clear()<cr>")
    vim.g.searchx = {
        auto_accept = true,
        markers = vim.split("ASDFGHJKL;QWERTYUIOP", ""),
    }
end

return M
