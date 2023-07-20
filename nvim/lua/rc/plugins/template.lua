---@type LazySpec
local spec = {
  "mattn/vim-sonictemplate",
  init = function()
    vim.g.sonictemplate_vim_template_dir = vim.fn.stdpath("config") .. "/template"
  end,
}

return spec
