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
      title = false,
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
        page_up = "<C-u>",
        page_down = "<C-d>",
        page_reset = "<C-g>",
      },
    },
  },

  files = {
    prompt = "Files❯ ",
    cmd = "fd -t f",
    git_icons = true,
    file_icons = true,
    color_icons = true,
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

  helptags = { previewer = { split = "topleft" } },
  manpages = { previewer = { split = "topleft" } },

  file_icon_padding = " ",

  lua_io = true,
})

local map = utils.map

map("n", "<F1>", "FzfLua builtin", "cmd")
map("n", "<leader>f", "FzfLua files", "cmd")
map("n", "<leader>b", "FzfLua buffers", "cmd")
map("n", "<leader>o", "FzfLua oldfiles", "cmd")
map("n", "<leader>h", "FzfLua help_tags", "cmd")
map("n", "<leader>m", "FzfLua man_pages", "cmd")
map("n", "<leader>gr", "FzfLua live_grep", "cmd")
map("x", "<leader>gr", "FzfLua grep_visual", "cmd")
map("n", "<leader>/", "FzfLua lines", "cmd")
map("n", "q:", "FzfLua command_history", "cmd")
map("n", "q/", "FzfLua search_history", "cmd")

map("n", "<leader>i", "FzfLua lsp_document_diagnostics", "cmd")
map("n", "<leader>I", "FzfLua lsp_workspace_diagnostics", "cmd")
map("n", "<leader>a", "FzfLua lsp_code_actions", "cmd")
map("n", "gd", "FzfLua lsp_definitions", "cmd")
map("n", "gr", "FzfLua lsp_references", "cmd")
