---@type LazySpec
local spec = {
  {
    "mattn/vim-sonictemplate",
    cmd = "Template",
    init = function()
      vim.g.sonictemplate_vim_template_dir = vim.fn.stdpath("config") .. "/template"
    end,
  },
}

return spec
