local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/ddc-source-vsnip",
  dev = true,
  dependencies = {
    "ddc.vim",
    "hrsh7th/vim-vsnip",
  },
  init = function()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
    vim.g.vsnip_choice_delay = 200
  end,
  config = function()
    helper.patch_global({
      sourceOptions = {
        vsnip = { mark = "[Vsnip]" },
      },
      sourceParams = {
        vsnip = { menu = false },
      },
    })
  end,
}

return spec
