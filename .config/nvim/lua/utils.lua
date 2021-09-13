_G.myutils = {}

_G.myluafunc = setmetatable({}, {
  __call = function(self, num)
    return self[num]()
  end,
})

local api = vim.api
local cmd = vim.cmd

---Return a string for vim from a lua function.
---Functions are stored in _G.myluafunc.
---@param func function
---@return string VimFunctionString
local func2str = function(func)
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  return ("lua myluafunc(%s)"):format(idx)
end

local fallback = function(key, mode)
  mode = mode or "n"
  return function()
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end
end

---API for key mapping.
---
---@param lhs string
---@param modes string|table
---@param rhs string|function|table
---@param opts string|table
--- opts.buffer: current buffer only
--- opts.cmd: command (format to <cmd>%s<cr>)
myutils.map = function(modes, lhs, rhs, opts)
  opts = opts or {}

  opts = type(opts) == "string" and { opts } or opts
  for key, opt in ipairs(opts) do
    opts[opt] = true
    opts[key] = nil
  end

  local buffer = (function()
    if opts.buffer then
      opts.buffer = nil
      return true
    end
  end)()

  rhs = type(rhs) ~= "table" and { rhs } or rhs
  rhs = table.concat(vim.tbl_map(function(r)
    local _rhs = (function()
      if type(r) == "function" then
        opts.cmd = true
        return func2str(function()
          r(fallback(lhs))
        end)
      else
        return r
      end
    end)()

    _rhs = (function()
      if opts.cmd then
        return ("<cmd>%s<cr>"):format(_rhs)
      else
        return _rhs
      end
    end)()
    return _rhs
  end, rhs))

  if opts.cmd then
    opts.noremap = true
    opts.cmd = nil
  end

  modes = type(modes) == "string" and { modes } or modes
  for _, mode in ipairs(modes) do
    if buffer then
      api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
    else
      api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
  end
end

---Exchange of two key
---
---@param modes any
---@param a string
---@param b string
---@param opts string|table
myutils.map_conv = function(modes, a, b, opts)
  myutils.map(modes, a, b, opts)
  myutils.map(modes, b, a, opts)
end

---API for autocmd. Supports for a lua funcion.
---
---@param au table
myutils.autocmd = function(au)
  if type(au[#au]) == "function" then
    au[#au] = func2str(au[#au])
  end
  cmd(table.concat(vim.tbl_flatten({ "au", au }), " "))
end

---API for augroup. Supports for a lua function.
---
---@param augrps table
-- augrps key: group name, value: an argument of utils.autocmd
myutils.augroup = function(augrps)
  for group, aus in pairs(augrps) do
    cmd("augroup " .. group)
    cmd("au!")
    for _, au in ipairs(aus) do
      if type(au) ~= "table" then
        myutils.autocmd(aus)
        break
      end
      myutils.autocmd(au)
    end
    cmd("augroup END")
  end
end

---API for command. Supports for a lua function
---
---@param command string|table
myutils.command = function(command)
  if type(command) == "table" then
    if type(command[#command]) == "function" then
      command[#command] = func2str(command[#command])
    end
    command = table.concat(command, " ")
  end
  cmd("com!" .. command)
end

---Execute a string as a function.
---@param inStr string
---@return any ReturnFunction
myutils.eval = function(inStr)
  return assert(load(inStr))()
end
