local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

fzf.setup({
    keymap = {
        builtin = {
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
        },
        fzf = {
            -- fzf '--bind=' options
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["ctrl-f"] = "preview-page-down",
            ["ctrl-b"] = "preview-page-up",
        },
    },
    file_icon_padding = " ",
    files = {
        actions = {
            ["ctrl-x"] = actions.file_split,
        },
    },
    git = {
        actions = {
            ["ctrl-x"] = actions.file_split,
        },
    },
})

local map = vim_api.map

map("n", "<F1>", "<cmd>FzfLua builtin<cr>")
map("n", "<leader>r", "<cmd>FzfLua resume<cr>")
map("n", "<leader>f", "<cmd>FzfLua files<cr>")
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>o", "<cmd>FzfLua oldfiles<cr>")
map("n", "<leader>h", "<cmd>FzfLua help_tags<cr>")
map("n", "<leader>m", "<cmd>FzfLua man_pages<cr>")
map("n", "<leader>gr", "<cmd>FzfLua live_grep<cr>")
map("n", "<leader>/", "<cmd>FzfLua blines<cr>")
map("n", "<leader>gf", "<cmd>FzfLua git_files<cr>")
map("n", "q:", "<cmd>FzfLua command_history<cr>")
map("n", "q/", "<cmd>FzfLua search_history<cr>")

map("n", "<leader>i", "<cmd>FzfLua lsp_document_diagnostics<cr>")
map("n", "<leader>I", "<cmd>FzfLua lsp_workspace_diagnostics<cr>")
map("n", "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")
map("n", "gd", function()
    fzf.lsp_definitions({ jump_to_single_result = true })
end)
map("n", "gr", "<cmd>FzfLua lsp_references<cr>")
