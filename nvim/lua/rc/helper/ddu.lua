local M = {}
M.callback = {}

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
---@return string | function
function M.action(name, params, stopinsert, callback)
  if stopinsert then
    local id = #M.callback + 1
    table.insert(M.callback, function()
      vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
      safe_call(callback)
    end)
    return ("<Esc><Cmd>lua require('rc.helper.ddu').callback[%d]()<CR>"):format(id)
  else
    return function()
      vim.fn["ddu#ui#do_action"](name, params or vim.empty_dict())
      safe_call(callback)
    end
  end
end

---@param name string
---@param params? table
---@param stopinsert? boolean
---@param callback? string | function
---@return string | function
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
