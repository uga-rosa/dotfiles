local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "hrsh7th/vim-vsnip",
  dependencies = "ddc.vim",
  init = function()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
    vim.g.vsnip_choice_delay = 200
  end,
  config = function()
    helper.patch_global({
      sourceOptions = {
        vsnip = { mark = "[Vsnip]" },
      },
    })
  end,
}

return spec