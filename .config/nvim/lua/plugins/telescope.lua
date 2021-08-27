local map = utils.map

map("n", "<F1>", "<cmd>Telescope builtin<cr>")
map("n", "<leader>f", "<cmd>Telescope fd<cr>")
map("n", "<leader>b", "<cmd>Telescope buffers<cr>")
map("n", "<leader>o", "<cmd>Telescope oldfiles<cr>")
map("n", "<leader>h", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>rg", "<cmd>Telescope grep_string<cr>")
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
map("n", "q:", "<cmd>Telescope command_history<cr>")
map("n", "q/", "<cmd>Telescope search_history<cr>")

map("n", "<leader>i", "<cmd>Telescope lsp_document_diagnostics<cr>")
map("n", "<leader>I", "<cmd>Telescope lsp_workspace_diagnostics<cr>")
map("n", "<leader>a", "<cmd>Telescope lsp_code_actions<cr>")
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
map("n", "gr", "<cmd>Telescope lsp_references<cr>")

local telescope = require("telescope")

telescope.setup({
  pickers = {
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
        n = {
          ["<C-d>"] = "delete_buffer",
        },
      },
    },
  },
})
