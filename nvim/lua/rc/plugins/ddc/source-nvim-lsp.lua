local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc-source-nvim-lsp",
  dev = true,
  name = "ddc-source-nvim-lsp",
  dependencies = {
    "ddc.vim",
    {
      "uga-rosa/ddc-nvim-lsp-setup",
      dev = true,
    },
  },
  config = function()
    -- require("ddc_nvim_lsp.internal").setup({ debug = true })

    helper.patch_global({
      sourceOptions = {
        ["nvim-lsp"] = {
          mark = "[LSP]",
          dup = "keep",
          keywordPattern = "\\k*",
          sorters = { "sorter_fuzzy", "sorter_lsp-kind" },
        },
      },
      sourceParams = {
        ["nvim-lsp"] = {
          snippetEngine = helper.register(function(body)
            vim.fn["vsnip#anonymous"](body)
          end),
          enableResolveItem = true,
          enableAdditionalTextEdit = true,
          confirmBehavior = "replace",
        },
      },
    })
  end,
}

return spec
