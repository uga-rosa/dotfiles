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
        vsnip = {
          mark = "[Vsnip]",
          keywordPattern = "\\S*",
        },
      },
      sourceParams = {
        vsnip = { menu = false },
      },
    })

    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if vim.bool_fn["vsnip#jumpable"](1) then
        return "<Plug>(vsnip-jump-next)"
      else
        return "<Tab>"
      end
    end, { expr = true, replace_keycodes = true })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if vim.bool_fn["vsnip#jumpable"](-1) then
        return "<Plug>(vsnip-jump-prev)"
      else
        return "<S-Tab>"
      end
    end, { expr = true, replace_keycodes = true })
  end,
}

return spec
