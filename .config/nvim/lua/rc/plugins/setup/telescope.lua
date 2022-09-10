-- mapping
local map = Keymap.set

map("n", "<F1>", "<Cmd>Telescope builtin<CR>")
map("n", "<leader>r", "<Cmd>Telescope resume<CR>")
map("n", "<leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<leader>b", "<Cmd>Telescope buffers<CR>")
map("n", "<leader>o", "<Cmd>Telescope frecency<CR>")
map("n", "<leader>gr", "<Cmd>Telescope live_grep<CR>")
map("n", "<leader>/", "<Cmd>Telescope blines<CR>")
map("n", "<leader>gf", "<Cmd>Telescope git_files<CR>")
map("n", "<leader>h", "<Cmd>Telescope help_tags<CR>")
map("n", "q:", "<Cmd>Telescope command_history<CR>")
map("n", "q/", "<Cmd>Telescope search_history<CR>")

map("n", "<leader>i", "<Cmd>Telescope diagnostics<CR>")
map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
map("n", "gr", "<Cmd>Telescope lsp_references<CR>")
