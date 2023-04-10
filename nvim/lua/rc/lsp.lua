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
      suffix = {},
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

local handlers = {
  hover = vim.lsp.with(vim.lsp.handlers.hover, opts.hover),
  signature_help = vim.lsp.with(vim.lsp.handlers.signature_help, opts.signature_help),
}

---@param s string
---@return string
local function br2lf(s)
  s = s:gsub("<br>", "\n")
  return s
end

---@param err any
---@param result? Hover
---@param ctx any
---@param config? table
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  if result then
    if type(result.contents) == "string" then
      ---@cast result {contents: string}
      result.contents = br2lf(result.contents)
    elseif result.contents.value then
      if result.contents.language or result.contents.kind == "markdown" then
        result.contents.value = br2lf(result.contents.value)
      end
    elseif vim.tbl_islist(result.contents) then
      ---@cast result {contents: MarkedString[]}
      for i, v in ipairs(result.contents) do
        if type(v) == "string" then
          result.contents[i] = br2lf(v)
        else
          v.value = br2lf(v.value)
        end
      end
    end
  end
  config = config or {}
  config.max_width = 80
  handlers.hover(err, result, ctx, config)
end

vim.diagnostic.config(opts.diagnostic)

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  handlers.signature_help(err, result, ctx, config)
end
