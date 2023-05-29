local M = {}

---Register callback function on LspAttach
---@param callback fun(client, bufnr)
function M.on_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, bufnr)
    end,
  })
end

---@param method string
---@param params table|nil
---@param options table|nil
---@param handler function
local function request(method, params, options, handler)
  vim.lsp.buf_request(0, method, params, function(err, result, ctx, config)
    config = vim.tbl_extend("force", config or {}, options  or {})
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client.handlers[method] then
      client.handlers[method](err, result, ctx, { on_list = function() end })
    end
    handler(err, result, ctx, config)
  end)
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

---@class Option
---@field reuse_win boolean Jump to existing window if buffer is already open.

---@param options Option|nil
function M.definition(options)
  local handler = location_handler("Definition")
  local params = vim.lsp.util.make_position_params()
  request("textDocument/definition", params, options, handler)
end

---@param options Option|nil
function M.declaration(options)
  local handler = location_handler("Declaration")
  local params = vim.lsp.util.make_position_params()
  request("textDocument/definition", params, options, handler)
end

---@param options Option|nil
function M.type_definition(options)
  local handler = location_handler("Type definition")
  local params = vim.lsp.util.make_position_params()
  request("textDocument/definition", params, options, handler)
end

---@param options Option|nil
function M.implementation(options)
  local handler = location_handler("Implementation")
  local params = vim.lsp.util.make_position_params()
  request("textDocument/definition", params, options, handler)
end

---@param context table Context for the request
function M.references(context)
  local params = vim.lsp.util.make_position_params()
  params.context = context or {
    includeDeclaration = true,
  }
  request("textDocument/references", params, nil, function(_, result, _, _)
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
  end)
end

return M
