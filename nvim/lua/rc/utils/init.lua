local M = {}

---@param cmd string|function
function M.keep_cursor(cmd)
  local win_id = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  pcall(function()
    if type(cmd) == "string" then
      vim.cmd(cmd)
    elseif type(cmd) == "function" then
      cmd()
    end
  end)
  if vim.api.nvim_get_current_win() == win_id then
    vim.fn.winrestview(view)
  end
end

---@param path string?
---@return string? root_dir
function M.find_root(path)
  path = path or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return vim
    .iter(vim.fs.find(".git", {
      upward = true,
      path = path,
    }))
    :map(vim.fs.dirname)
    :totable()[1]
end

---@param package_name string
---@param key unknown
---@param value unknown
function M.package_set(package_name, key, value)
  local module = (package.preload[package_name] or function()
    return {}
  end)()
  module[key] = value
  package.preload[package_name] = function()
    return module
  end
end

---@param fn function
---@param ... unknown Arguments
---@return function
function M.call_with(fn, ...)
  local args = { ... }
  return function()
    fn(unpack(args))
  end
end

---@generic T
---@param arr T[]
---@param callback? fun(x: T): number
---@return number
function M.max(arr, callback)
  assert(#arr > 0, "Array is empty")
  local max_value = -math.huge
  for _, elem in ipairs(arr) do
    local m = callback and callback(elem) or elem
    if m > max_value then
      max_value = m
    end
  end
  return max_value
end

---@generic T
---@param arr T[]
---@param callback? fun(x: T): number
---@return number
function M.min(arr, callback)
  assert(#arr > 0, "Array is empty")
  local min_value = math.huge
  for _, elem in ipairs(arr) do
    local m = callback and callback(elem) or elem
    if m < min_value then
      min_value = m
    end
  end
  return min_value
end

local timer = {}

---@param name string
local function timer_reset(name)
  if timer[name] then
    timer[name]:stop()
    timer[name]:close()
    timer[name] = nil
  end
end

---@param name string
---@param fn function
---@param time number milliseconds
function M.debounse(name, fn, time)
  timer_reset(name)
  timer[name] = vim.uv.new_timer()
  timer[name]:start(
    time,
    0,
    vim.schedule_wrap(function()
      fn()
      timer_reset(name)
    end)
  )
end

---@generic T
---@param list T[]
---@return T[]
function M.deduplicate(list)
  local set = {}
  local ret = {}
  for _, elem in ipairs(list) do
    if set[elem] == nil then
      set[elem] = true
      table.insert(ret, elem)
    end
  end
  return ret
end

return M
