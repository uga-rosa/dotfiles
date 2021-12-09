local fzf = require("fzf-lua")

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
})

local map = vim_api.map

map("n", "<F1>", "FzfLua builtin", "cmd")
map("n", "<leader>f", "FzfLua files", "cmd")
map("n", "<leader>b", "FzfLua buffers", "cmd")
map("n", "<leader>o", "FzfLua oldfiles", "cmd")
map("n", "<leader>h", "FzfLua help_tags", "cmd")
map("n", "<leader>m", "FzfLua man_pages", "cmd")
map("n", "<leader>rg", "FzfLua live_grep_resume", "cmd")
map("n", "<leader>/", "FzfLua blines", "cmd")
map("n", "<leader>gf", "FzfLua git_files", "cmd")
map("n", "q:", "FzfLua command_history", "cmd")
map("n", "q/", "FzfLua search_history", "cmd")

map("n", "<leader>i", "FzfLua lsp_document_diagnostics", "cmd")
map("n", "<leader>I", "FzfLua lsp_workspace_diagnostics", "cmd")
map("n", "<leader>a", "FzfLua lsp_code_actions", "cmd")
map("n", "gd", function()
    fzf.lsp_definitions({ jump_to_single_result = true })
end, "cmd")
map("n", "gr", "FzfLua lsp_references", "cmd")
