-- mapping
vim.keymap.set("n", "<F1>", "<Cmd>Telescope builtin<CR>")
vim.keymap.set("n", "<leader>r", "<Cmd>Telescope resume<CR>")
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files hidden=true<CR>")
vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>o", "<Cmd>Telescope frecency<CR>")
vim.keymap.set("n", "<leader>lg", "<Cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>/", "<Cmd>Telescope blines<CR>")
vim.keymap.set("n", "<leader>gf", "<Cmd>Telescope git_files<CR>")
vim.keymap.set("n", "<leader>h", "<Cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "q:", "<Cmd>Telescope command_history<CR>")
vim.keymap.set("n", "q/", "<Cmd>Telescope search_history<CR>")

-- LSP
vim.keymap.set("n", "<leader>i", "<Cmd>Telescope diagnostics<CR>")
vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
