local res, toggleterm = pcall(require, "toggleterm")
if not res then
  return
end

local map = utils.map
local augroup = utils.augroup

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<M-t>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = "<number>",
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "double",
    width = 150,
    height = 100,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
})
_G.lazy_git_toggle = function()
  lazygit:toggle()
end

map("n", "<leader>l", "lua lazy_git_toggle()", { "noremap", "cmd" })

augroup({
  MyTerm = {
    {
      "FileType",
      "rust",
      function()
        map("n", "@r", "TermExec cmd='cargo run'", { "noremap", "buffer", "cmd" })
        map("n", "@t", "TermExec cmd='cargo test'", { "noremap", "buffer", "cmd" })
        map("n", "@c", "TermExec cmd='cargo check'", { "noremap", "buffer", "cmd" })
      end,
    },
    {
      "FileType",
      "python",
      function()
        map("n", "@r", "TermExec cmd='python %'", { "noremap", "buffer", "cmd" })
      end,
    },
  },
})
