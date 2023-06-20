local utils = require("rc.utils")

local M = {}

---@class Source
---@field [1] string name
---@field params table

---@param name string
---@param source string|Source|(Source|string)[]
---@param config? table
function M.start(name, source, config)
  config = config or {}
  local sources = {}
  if type(source) == "string" then
    -- string
    sources = { { name = source } }
  elseif source.params then
    -- Source
    source.name, source[1] = source[1], nil
    sources = { source }
  else
    -- Source[]
    for i, s in ipairs(source) do
      if type(s) == "string" then
        source[i] = { name = s }
      else
        s.name, s[1] = s[1], nil
      end
    end
    sources = source
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

---@param name string
---@param params? table
---@param stopinsert? boolean
---@return function
function M.action(name, params, stopinsert)
  return function()
    if stopinsert then
      vim.cmd.stopinsert()
      vim.schedule(function()
        vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
      end)
    else
      vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
    end
  end
end

---@param name string
---@param params? table
---@param stopinsert? boolean
---@return function
function M.item_action(name, params, stopinsert)
  return M.action("itemAction", { name = name, params = params }, stopinsert)
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
---@param callback fun(map: fun(lhs: string, rhs: string|function))
function M.ff_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-map-" .. name, {}),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or vim.startswith(vim.b.ddu_ui_name, name) then
        callback(function(lhs, rhs)
          vim.keymap.set("n", lhs, rhs, { nowait = true, buffer = true, silent = true })
        end)
      end
    end,
  })
end

---@param name? string If nil, map is set globally
---@param callback fun(map: fun(mode: string|string[], lhs: string, rhs: string|function))
function M.ff_filter_map(name, callback)
  name = name or "default"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff-filter",
    group = vim.api.nvim_create_augroup("ddu-ui-ff-filter-map-" .. name, {}),
    callback = function()
      -- Enable `file` map also for `file:foo`
      if name == "default" or vim.startswith(vim.b.ddu_ui_name, name) then
        callback(function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { nowait = true, buffer = true, silent = true })
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

return M
