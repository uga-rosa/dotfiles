local utils = require("rc.utils")

local M = {}

---@class Source
---@field [1] string name
---@field params? table
---@field options? table

---@param name string
---@param source string|Source|(Source|string)[]
---@param config? table
function M.start(name, source, config)
  config = config or {}
  local sources = {}
  if type(source) == "string" then
    -- string
    sources = { { name = source } }
  elseif vim.tbl_islist(source) then
    ---@cast source (Source|string)[]
    for i, s in ipairs(source) do
      if type(s) == "string" then
        source[i] = { name = s }
      else
        s.name, s[1] = s[1], nil
      end
    end
    sources = source
  else
    -- Source
    source.name, source[1] = source[1], nil
    sources = { source }
  end
  config.sources = sources
  config.name = name
  vim.fn["ddu#start"](config)
end

---Register sub command
---@param name string
---@param callback function
function M.register(name, callback)
  utils.package_set("ddu_command", name, callback)
end

---@param fn? string | function
---@param ... unknown
local function safe_call(fn, ...)
  fn = type(fn) == "string" and vim.fn[fn] or fn --[[@as function?]]
  if fn then
    fn(...)
  end
end

---@param name string
---@param params? table
---@param stopinsert? boolean
---@param callback? string | function
---@return function
function M.action(name, params, stopinsert, callback)
  return function()
    if stopinsert then
      vim.cmd.stopinsert()
      vim.schedule(function()
        vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
        safe_call(callback)
      end)
    else
      vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
      safe_call(callback)
    end
  end
end

---@param name string
---@param params? table
---@param stopinsert? boolean
---@param callback? string | function
---@return function
function M.item_action(name, params, stopinsert, callback)
  return M.action("itemAction", { name = name, params = params }, stopinsert, callback)
end

---@param cmd string
---@return function
function M.execute(cmd)
  return function()
    vim.fn["ddu#ui#ff#execute"](cmd)
    vim.cmd.redraw()
  end
end

---@param name? string If nil, map is set globally
---@param callback fun(map: fun(lhs: string, rhs: string|function, opts?: table))
function M.ff_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-map-" .. name, { clear = false }),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or string.find(vim.b.ddu_ui_name, name) then
        callback(function(lhs, rhs, opts)
          opts = vim.tbl_extend("keep", opts or {}, { nowait = true, buffer = true, silent = true })
          vim.keymap.set("n", lhs, rhs, opts)
        end)
      end
    end,
  })
end

---@param name? string If nil, map is set globally
---@param callback fun(map: fun(mode: string|string[], lhs: string, rhs: string|function, opts?: table))
function M.ff_filter_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff-filter",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-filter-map-" .. name, { clear = false }),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or string.find(vim.b.ddu_ui_name, name) then
        callback(function(mode, lhs, rhs, opts)
          opts = vim.tbl_extend("keep", opts or {}, { nowait = true, buffer = true, silent = true })
          vim.keymap.set(mode, lhs, rhs, opts)
        end)
      end
    end,
  })
end

---@param dict table
function M.patch_global(dict)
  vim.fn["ddu#custom#patch_global"](dict)
end

---@param name string
---@param dict table
function M.patch_local(name, dict)
  vim.fn["ddu#custom#patch_local"](name, dict)
end

---@param type "ui"|"source"|"filter"|"kind"|"column"|"action"
---@param alias_name string
---@param base_name string
function M.alias(type, alias_name, base_name)
  vim.fn["ddu#custom#alias"](type, alias_name, base_name)
end

return M
