---@type PluginSpec
local spec = {
  "haya14busa/vim-asterisk",
  keys = {
    { "*", "<Plug>(asterisk-z*)", mode = { "n", "x", "o" } },
    { "#", "<Plug>(asterisk-z#)", mode = { "n", "x", "o" } },
    { "g*", "<Plug>(asterisk-gz*)", mode = { "n", "x", "o" } },
    { "g#", "<Plug>(asterisk-gz#)", mode = { "n", "x", "o" } },
  },
  setup = function()
    vim.g["asterisk#keeppos"] = 1
  end,
}

return spec
