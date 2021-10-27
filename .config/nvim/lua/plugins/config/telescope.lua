local map = myutils.map

require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

require("telescope").load_extension("fzf")

map("n", "<F1>", "Telescope builtin", "cmd")
map("n", "<leader>f", "Telescope fd", "cmd")
map("n", "<leader>b", "Telescope buffers", "cmd")
map("n", "<leader>o", "Telescope oldfiles", "cmd")
map("n", "<leader>h", "Telescope help_tags", "cmd")
map("n", "<leader>m", "Telescope man_pages", "cmd")
map("n", "<leader>rg", "Telescope live_grep", "cmd")
map("n", "<leader>/", "Telescope current_buffer_fuzzy_find", "cmd")
map("n", "<leader>t", "Telescope treesitter", "cmd")
map("n", "<leader>gf", "Telescope git_files", "cmd")
map("n", "q:", "Telescope command_history", "cmd")
map("n", "q/", "Telescope search_history", "cmd")

map("n", "<leader>i", "Telescope lsp_document_diagnostics", "cmd")
map("n", "<leader>I", "Telescope lsp_workspace_diagnostics", "cmd")
map("n", "<leader>a", "Telescope lsp_code_actions", "cmd")
map("n", "gd", "Telescope lsp_definitions", "cmd")
map("n", "gr", "Telescope lsp_references", "cmd")
