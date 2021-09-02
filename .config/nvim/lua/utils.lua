utils = {}

_G.myluafunc = setmetatable({}, {
  __call = function(self, num)
    return self[num]()
  end,
})

local api = vim.api
local cmd = vim.cmd

--@param func: function
--@param map:  boolean
utils.lua2vim = function(func, map)
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  local command = ("lua myluafunc(%s)"):format(idx)
  command = map and ("<cmd>%s<cr>"):format(command) or command
  return command
end

--@param modes: string or array
--@param lhs:   string or array
--@param rhs:   string or function
--@param opts:  string or array (including "buffer")
utils.map = function(modes, lhs, rhs, opts)
  modes = type(modes) == "string" and { modes } or modes
  lhs = type(lhs) == "string" and { lhs } or lhs
  opts = opts or {}
  opts = type(opts) == "string" and { opts } or opts

  if type(rhs) == "function" then
    opts.noremap = true
    local map = not opts.expr
    rhs = utils.lua2vim(rhs, map)
  end

  local buffer = false
  for key, opt in ipairs(opts) do
    if opt == "buffer" then
      buffer = true
    else
      opts[opt] = true
    end
    opts[key] = nil
  end

  for _, mode in ipairs(modes) do
    for _, l in ipairs(lhs) do
      if buffer then
        api.nvim_buf_set_keymap(0, mode, l, rhs, opts)
      else
        api.nvim_set_keymap(mode, l, rhs, opts)
      end
    end
  end
end

utils.map_conv = function(modes, a, b, opts)
  utils.map(modes, a, b, opts)
  utils.map(modes, b, a, opts)
end

utils.t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

--@param au: string or array
utils.autocmd = function(au)
  local command
  if type(au) == "table" then
    if type(au[#au]) == "function" then
      au[#au] = utils.lua2vim(au[#au])
    end
    command = table.concat(vim.tbl_flatten({ "au", au }), " ")
  else
    assert(type(au) == "string", "Invalid arguments type: " .. type(au))
    command = au
  end
  cmd(command)
end

--@param group: string
--@param aus:   string in array or array in array
utils.augroup = function(group, aus)
  cmd("augroup " .. group)
  cmd("au!")
  for _, au in ipairs(aus) do
    utils.autocmd(au)
  end
  cmd("augroup END")
end

utils.eval = function(inStr)
  return assert(load(inStr))()
end

utils.is_array = function(table)
  local count = 0
  for k, _ in pairs(table) do
    count = count + 1
    if not (type(k) == "number" and k > 0) then
      return false
    end
  end
  if #table == count then
    return true
  end
  return false
end

utils.set = {}
local Set = {}

utils.set.new = function(arr)
  assert(utils.is_array(arr), "Args must be array-like table.")
  return setmetatable(arr, { __index = Set })
end

function Set:diff(arr)
  local result = setmetatable({}, { __index = table })
  for _, v in ipairs(self) do
    if not vim.tbl_contains(arr, v) then
      result:insert(v)
    end
  end
  return result
end
