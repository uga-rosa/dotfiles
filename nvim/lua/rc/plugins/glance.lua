---@type PluginSpec
local spec = {
  "tani/vim-glance",
  enabled = false,
  dependencies = "denops.vim",
  config = function()
    vim.g["glance#stylesheet"] = ""
  end,
}

return spec
