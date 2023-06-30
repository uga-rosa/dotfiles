local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc-source-nvim-lsp",
  dependencies = {
    "ddc.vim",
    {
      "uga-rosa/ddc-nvim-lsp-setup",
      dev = true,
    },
    "neovim/nvim-lspconfig",
  },
  dev = true,
  config = function()
    require("ddc_nvim_lsp_setup").setup()

    helper.patch_global({
      sourceOptions = {
        ["nvim-lsp"] = {
          mark = "[LSP]",
          dup = "keep",
        },
      },
      sourceParams = {
        ["nvim-lsp"] = {
          snippetEngine = helper.register(function(body)
            vim.fn["vsnip#anonymous"](body)
          end),
          enableResolveItem = true,
          enableAdditionalTextEdit = true,
          confirmBehavior = "insert",
        },
      },
    })
  end,
}

return spec