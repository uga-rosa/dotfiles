---@type LazySpec
local spec = {
  {
    "uga-rosa/vim-edgemotion",
    keys = {
      { "<C-j>", "<Plug>(edgemotion-j)", mode = { "n", "x", "o" } },
      { "<C-k>", "<Plug>(edgemotion-k)", mode = { "n", "x", "o" } },
    },
  },
}

return spec
