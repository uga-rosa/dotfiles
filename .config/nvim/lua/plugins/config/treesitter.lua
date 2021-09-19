local map = myutils.map
local augroup = myutils.augroup

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>s"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>S"] = "@parameter.inner",
      },
    },
  },
})

map("x", "iu", ':lua require("treesitter-unit").select()<cr>', "noremap")
map("x", "au", ':lua require("treesitter-unit").select(true)<cr>', "noremap")
map("o", "iu", 'lua require("treesitter-unit").select()', { "noremap", "cmd" })
map("o", "au", 'lua require("treesitter-unit").select(true)', { "noremap", "cmd" })

local tsunit = require("treesitter-unit")

local operators = { "c", "d", "y", "=", "<", ">" }
for _, o in ipairs(operators) do
  map("n", o, '<cmd>lua require("treesitter-unit").enable_highlighting()<cr>' .. o, "noremap")
end

augroup({ tsunit = { "CursorMoved", "*", tsunit.disable_highlighting } })
