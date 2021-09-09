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
local func2str = function(func, mapping)
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  local command = ("lua myluafunc(%s)"):format(idx)
  command = mapping and ("<cmd>%s<cr>"):format(command) or command
  return command
end

utils.t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

--@param modes: string or array
--@param lhs:   string
--@param rhs:   string or function
--@param opts:  string or array (including "buffer")
utils.map = function(modes, lhs, rhs, opts)
  modes = type(modes) == "string" and { modes } or modes
  opts = opts or {}
  opts = type(opts) == "string" and { opts } or opts

  local fallback = function()
    return api.nvim_feedkeys(utils.t(lhs), "n", true)
  end

  local _rhs = (function()
    if type(rhs) == "function" then
      opts.noremap = true
      return func2str(function()
        rhs(fallback)
      end, true)
    else
      return rhs
    end
  end)()

  for key, opt in ipairs(opts) do
    opts[opt] = true
    opts[key] = nil
  end

  local buffer = (function()
    if opts["buffer"] then
      opts["buffer"] = nil
      return true
    end
  end)()

  for _, mode in ipairs(modes) do
    if buffer then
      api.nvim_buf_set_keymap(0, mode, lhs, _rhs, opts)
    else
      api.nvim_set_keymap(mode, lhs, _rhs, opts)
    end
  end
end

utils.map_conv = function(modes, a, b, opts)
  utils.map(modes, a, b, opts)
  utils.map(modes, b, a, opts)
end

--@param au: string or array
utils.autocmd = function(au)
  if type(au[#au]) == "function" then
    au[#au] = func2str(au[#au], false)
  end
  cmd(table.concat(vim.tbl_flatten({ "au", au }), " "))
end

--@param augrps: table (key: group name, value: autocmd (array-like table))
utils.augroup = function(augrps)
  for group, aus in pairs(augrps) do
    cmd("augroup " .. group)
    cmd("au!")
    for _, au in ipairs(aus) do
      if type(au) ~= "table" then
        utils.autocmd(aus)
        break
      end
      utils.autocmd(au)
    end
    cmd("augroup END")
  end
end

utils.eval = function(inStr)
  return assert(load(inStr))()
end

table.is_array = function(self)
  local count = 0
  for k, _ in pairs(self) do
    count = count + 1
    if not (type(k) == "number" and k > 0) then
      return false
    end
  end
  if #self == count then
    return true
  end
  return false
end

utils.set = {}

local Set = {}

utils.set.unique = function(self)
  local check = {}
  local res = {}
  for _, v in ipairs(self) do
    if not check[v] then
      check[v] = true
      res[#res + 1] = v
    end
  end
  return res
end

utils.set.new = function(arr)
  assert(table.is_array(arr), "Args must be array-like table.")
  local res = utils.set.unique(arr)
  return setmetatable(res, { __index = Set })
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

utils.string = {}

--@param self string
--@param delim string
--@return array-like table
utils.string.split = function(self, delim)
  delim = delim or " "
  local res = {}
  for i in self:gmatch(("[^%s]+"):format(delim)) do
    res[#res + 1] = i
  end
  return res
end

--@param self string
--@param delim string
--@param count int
--@return string
-- example: string.rep("-", "|", 3) -> "|-|-|-|"
utils.string.rep = function(self, delim, count)
  local res = delim
  for _ = 1, count do
    res = res .. self .. delim
  end
  return res
end

--@param self string
--@return string
utils.string.trim = function(self)
  return self:gsub("^%s*(.-)%s*$", "%1")
end

_G.matrix = {}

--@param line int
--@param col int
--@param fill any
--@return matrix
matrix.new = function(line, col, fill)
  local arr = {}
  fill = fill or 0
  for i = 1, line do
    for j = 1, col do
      arr[i][j] = fill
    end
  end
  return setmetatable(arr, { __index = matrix })
end
