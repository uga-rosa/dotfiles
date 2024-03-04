---@type PluginSpec
local spec = {
  "mattn/vim-sonictemplate",
  setup = function()
    vim.g.sonictemplate_vim_template_dir = vim.fn.stdpath("config") .. "/template"
  end,
}

return spec
