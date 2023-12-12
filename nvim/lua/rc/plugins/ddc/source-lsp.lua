local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc-source-lsp",
  dev = true,
  name = "ddc-source-lsp",
  dependencies = {
    "ddc.vim",
  },
  config = function()
    -- require("ddc_nvim_lsp.internal").setup({ debug = true })

    helper.patch_global({
      sourceOptions = {
        lsp = {
          mark = "[LSP]",
          dup = "keep",
          keywordPattern = "\\k+",
          sorters = { "sorter_fuzzy", "sorter_lsp-kind", "exact" },
        },
      },
      sourceParams = {
        lsp = {
          lspEngine = "nvim-lsp",
          snippetEngine = helper.register(function(body)
            vim.fn["denippet#anonymous"](body)
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
