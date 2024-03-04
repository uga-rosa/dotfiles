---@type PluginSpec
local spec = {
  "haya14busa/vim-edgemotion",
  keys = {
    { "<C-j>", "<Plug>(edgemotion-j)", mode = { "n", "x", "o" } },
    { "<C-k>", "<Plug>(edgemotion-k)", mode = { "n", "x", "o" } },
  },
}

return spec
