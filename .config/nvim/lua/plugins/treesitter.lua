local map = utils.map

require("nvim-treesitter.configs").setup({
  ensure_installed = "maintained",
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
map("o", "iu", '<cmd>lua require("treesitter-unit").select()<cr>', "noremap")
map("o", "au", '<cmd>lua require("treesitter-unit").select(true)<cr>', "noremap")

do
  local timer = vim.loop.new_timer()
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      local mode = vim.fn.mode(1)
      if vim.g.treesitter_unit_highlight and mode == "n" then
        require("treesitter-unit").disable_highlighting()
        vim.g.treesitter_unit_highlight = false
      end
    end)
  )
end

_G.TSUnitHlEnable = function()
  require("treesitter-unit").enable_highlighting()
  vim.g.treesitter_unit_highlight = true
end

local operators = { "c", "d", "y", "=", "<", ">" }
for _, o in ipairs(operators) do
  map("n", o, "<cmd>lua TSUnitHlEnable()<cr>" .. o, "noremap")
end
