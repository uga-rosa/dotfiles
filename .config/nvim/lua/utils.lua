local api = vim.api
local cmd = vim.cmd

_G.myutils = {}

_G.myluafunc = setmetatable({}, {
  __call = function(self, num)
    return self[num]()
  end,
})

---Return a string for vim from a lua function. Functions are stored in _G.myluafunc.
---@param func function
---@return string VimFunctionString
local function func2str(func)
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  return ("lua myluafunc(%s)"):format(idx)
end

function myutils.feedkey(key, mode)
  mode = mode or "n"
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function fallback(key)
  return function()
    myutils.feedkey(key)
  end
end

---API for key mapping.
---T : fun(fallback: function)
---@generic T fun(fallback: function)
---@param modes string|string[]
---@param lhs string
---@param rhs string|string[]|T|T[]
---@param opts string|string[]
---@overload fun(modes: string, lhs: string, rhs: string)
---opts.nowait: This make a shortest match.
---opts.silent: No echo.
---opts.expr: Deprecated. Use feedkeys().
---opts.buffer: current buffer only
---opts.cmd: command (format to <cmd>%s<cr>)
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
  local _rhs = {}

  for i = 1, #rhs do
    if type(rhs[i]) == "function" then
      opts.cmd = true
      _rhs[i] = func2str(function()
        rhs[i](fallback(lhs))
      end)
    else
      _rhs[i] = rhs[i]
    end
    if opts.cmd then
      _rhs[i] = "<cmd>" .. _rhs[i] .. "<cr>"
    end
  end
  _rhs = table.concat(_rhs, "")

  if opts.cmd then
    opts.noremap = true
    opts.cmd = nil
  end

  modes = type(modes) == "string" and { modes } or modes
  for _, mode in ipairs(modes) do
    if buffer then
      api.nvim_buf_set_keymap(0, mode, lhs, _rhs, opts)
    else
      api.nvim_set_keymap(mode, lhs, _rhs, opts)
    end
  end
end

---Exchange of two key
---@param modes string|string[]
---@param a string
---@param b string
---@param opts string|string[]
---@overload fun(modes: string, a: string, b: string)
---opts.nowait: This make a shortest match.
---opts.silent: No echo.
---opts.expr: Deprecated. Use feedkeys().
---opts.buffer: current buffer only
---opts.cmd: command (format to <cmd>%s<cr>)
myutils.map_conv = function(modes, a, b, opts)
  myutils.map(modes, a, b, opts)
  myutils.map(modes, b, a, opts)
end

---API for autocmd. Supports for a lua funcion.
---@param au string[]
---The last element of au can be a function.
myutils.autocmd = function(au)
  if type(au[#au]) == "function" then
    au[#au] = func2str(au[#au])
  end
  cmd(table.concat(vim.tbl_flatten({ "au", au }), " "))
end

---API for augroup. Supports for a lua function.
---@param augroups table<string,string[]>
---augroups' key: group named
---augroups' value: an argument of myutils.autocmd
myutils.augroup = function(augroups)
  for group, aus in pairs(augroups) do
    cmd("augroup " .. group)
    cmd("au!")
    if type(aus[1]) == "table" then
      for i = 1, #aus do
        myutils.autocmd(aus[i])
      end
    else
      myutils.autocmd(aus)
    end
    cmd("augroup END")
  end
end

---API for command. Supports for a lua function
---@param command string|table
myutils.command = function(command)
  if type(command) == "table" then
    if type(command[#command]) == "function" then
      command[#command] = func2str(command[#command])
    end
    command = table.concat(command, " ")
  end
  cmd("com! " .. command)
end

---Execute a string as a function.
---@param inStr string
---@return any ReturnFunction
myutils.eval = function(inStr)
  return assert(load(inStr))()
end

---Transforms ctx into a human readable representation.
---@param ctx any
_G.dump = function(ctx)
  print(vim.inspect(ctx))
end
