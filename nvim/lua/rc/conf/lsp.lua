vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#011627" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white" })

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
  definition = vim.lsp.handlers["textDocument/definition"],
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

local function location_handler(title)
  return function(_, result, ctx, config)
    if result == nil or vim.tbl_isempty(result) then
      vim.notify("No location found", vim.log.levels.INFO)
      return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    config = config or {}

    if not vim.tbl_islist(result) then
      vim.lsp.util.jump_to_location(result, client.offset_encoding, config.reuse_win)
    elseif #result == 1 then
      vim.lsp.util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
    else
      require("rc.ddu").start({
        {
          name = "lsp_locations",
          params = {
            locations = result,
          },
        },
        uiParams = {
          ff = {
            floatingTitle = title,
          },
        },
      })
    end
  end
end

vim.lsp.handlers["textDocument/definition"] = location_handler("Definition")
vim.lsp.handlers["textDocument/declaration"] = location_handler("Declaration")
vim.lsp.handlers["textDocument/typeDefinition"] = location_handler("Type definition")
vim.lsp.handlers["textDocument/implementation"] = location_handler("Implementation")
vim.lsp.handlers["textDocument/references"] = function(_, result, _, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.notify("No references found", vim.log.levels.INFO)
  else
    require("rc.ddu").start({
      {
        name = "lsp_locations",
        params = {
          locations = result,
        },
      },
      uiParams = {
        ff = {
          floatingTitle = "References",
        },
      },
    })
  end
end
