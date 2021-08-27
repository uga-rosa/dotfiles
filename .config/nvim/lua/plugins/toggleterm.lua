local map = utils.map
local augroup = utils.augroup

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-t>]],
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

map("n", "<leader>g", "<cmd>lua lazy_git_toggle()<cr>", "noremap")

augroup("MyTerm", {
  {
    "FileType",
    "rust",
    function()
      map("n", "@r", [[<cmd>TermExec cmd='cargo run'<cr>]], { "noremap", "buffer" })
      map("n", "@t", [[<cmd>TermExec cmd='cargo test'<cr>]], { "noremap", "buffer" })
      map("n", "@c", [[<cmd>TermExec cmd='cargo check'<cr>]], { "noremap", "buffer" })
    end,
  },
  {
    "FileType",
    "python",
    function()
      map("n", "@r", [[<cmd>TermExec cmd='python %'<cr>]], { "noremap", "buffer" })
    end,
  },
})
