local actions = require("fzf-lua.actions")

require("fzf-lua").setup({
  files = {
    cmd = "fd -t f",
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
    },
  },

  oldfiles = {
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
    },
  },

  lsp = {
    icons = {
      Error = { icon = " ", color = "red" },
      Warning = { icon = " ", color = "yellow" },
      Information = { icon = " ", color = "blue" },
      Hint = { icon = " ", color = "magenta" },
    },
  },

  helptags = { previewer = { split = "topleft" } },
  manpages = { previewer = { split = "topleft" } },

  file_icon_padding = " ",
})

local map = myutils.map

map("n", "<F1>", "FzfLua builtin", "cmd")
map("n", "<leader>f", "FzfLua files", "cmd")
map("n", "<leader>b", "FzfLua buffers", "cmd")
map("n", "<leader>o", "FzfLua oldfiles", "cmd")
map("n", "<leader>h", "FzfLua help_tags", "cmd")
map("n", "<leader>m", "FzfLua man_pages", "cmd")
map("n", "<leader>rg", "FzfLua live_grep", "cmd")
map("x", "<leader>rg", "FzfLua grep_visual", "cmd")
map("n", "<leader>/", "FzfLua lines", "cmd")
map("n", "q:", "FzfLua command_history", "cmd")
map("n", "q/", "FzfLua search_history", "cmd")

map("n", "<leader>i", "FzfLua lsp_document_diagnostics", "cmd")
map("n", "<leader>I", "FzfLua lsp_workspace_diagnostics", "cmd")
map("n", "<leader>a", "FzfLua lsp_code_actions", "cmd")
map("n", "gd", "FzfLua lsp_definitions", "cmd")
map("n", "gr", "FzfLua lsp_references", "cmd")
