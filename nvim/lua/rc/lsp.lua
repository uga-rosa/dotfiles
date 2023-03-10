vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1d3b53" })
vim.api.nvim_set_hl(0, "Title", { bg = "#1d3b53" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = "#1d3b53" })

local opts = {
  hover = {
    border = "single",
    title = "Hover",
  },
  diagnostic = {
    float = {
      border = "single",
      title = "Diagnostics",
      header = {},
      format = function(diag)
        if diag.code then
          return ("[%s](%s): %s"):format(diag.source, diag.code, diag.message)
        else
          return ("[%s]: %s"):format(diag.source, diag.message)
        end
      end,
    },
  },
  signature_help = {
    border = "single",
  },
}

vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  result.contents.value = result.contents.value:gsub("<br>", "\n")
  vim.lsp.with(vim.lsp.handlers.hover, opts.hover)(err, result, ctx, config)
end

vim.diagnostic.config(opts.diagnostic)

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  vim.lsp.with(vim.lsp.handlers.signature_help, opts.signature_help)(err, result, ctx, config)
end
