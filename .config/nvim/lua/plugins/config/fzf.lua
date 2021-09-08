local res, fzf_lua = pcall(require, "fzf-lua")
if not res then
  return
end

local actions = require("fzf-lua.actions")

fzf_lua.setup({
  winopts = {
    win_height = 0.85,
    win_width = 0.80,
    win_row = 0.30,
    win_col = 0.50,
    win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    hl_normal = "Normal",
    hl_border = "FloatBorder",
  },

  fzf_layout = "reverse",
  fzf_args = "",
  fzf_binds = {
    "ctrl-f:page-down",
    "ctrl-b:page-up",
    "ctrl-a:toggle-all",
    "ctrl-l:clear-query",
  },

  preview_border = "border",
  preview_wrap = "nowrap",
  preview_opts = "nohidden",
  preview_vertical = "down:45%",
  preview_horizontal = "right:60%",
  preview_layout = "flex",
  flip_columns = 120,
  previewers = {
    builtin = {
      title = true,
      scrollbar = true,
      scrollchar = "█",
      wrap = false,
      syntax = true,
      syntax_limit_l = 0,
      syntax_limit_b = 1024 * 1024,
      expand = false,
      hl_cursor = "Cursor",
      hl_cursorline = "CursorLine",
      hl_range = "IncSearch",
      keymap = {
        toggle_full = nil,
        toggle_wrap = nil,
        toggle_hidden = nil,
        page_up = "<C-u>",
        page_down = "<C-d>",
        page_reset = "<C-g>",
      },
    },
  },

  files = {
    prompt = "Files❯ ",
    cmd = "fd -t f",
    git_icons = false,
    file_icons = true,
    color_icons = true,
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
    },
  },

  lsp = {
    prompt = "❯ ",
    cwd_only = false,
    async_or_timeout = true,
    file_icons = false,
    git_icons = false,
    lsp_icons = true,
    severity = "hint",
    icons = {
      Error = { icon = " ", color = "red" },
      Warning = { icon = " ", color = "yellow" },
      Information = { icon = " ", color = "blue" },
      Hint = { icon = " ", color = "magenta" },
    },
  },

  helptags = {
    previewer = "builtin",
  },

  file_icon_padding = " ",
})

local map = utils.map

map("n", "<F1>", "<cmd>FzfLua builtin<cr>")
map("n", "<leader>f", "<cmd>FzfLua files<cr>")
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>o", "<cmd>FzfLua oldfiles<cr>")
map("n", "<leader>h", "<cmd>FzfLua help_tags<cr>")
map("n", "<leader>rg", "<cmd>FzfLua live_grep<cr>")
map("x", "<leader>rg", "<cmd>FzfLua grep_visual<cr>")
map("n", "<leader>/", "<cmd>FzfLua lines<cr>")
map("n", "q:", "<cmd>FzfLua command_history<cr>")
map("n", "q/", "<cmd>FzfLua search_history<cr>")

map("n", "<leader>i", "<cmd>FzfLua lsp_document_diagnostics<cr>")
map("n", "<leader>I", "<cmd>FzfLua lsp_workspace_diagnostics<cr>")
map("n", "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")
map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>")
map("n", "gr", "<cmd>FzfLua lsp_references<cr>")
