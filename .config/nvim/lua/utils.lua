utils = {}

local api = vim.api
local cmd = vim.cmd

_G.myluafunc = setmetatable({}, {
  __call = function(self, num)
    return self[num]()
  end,
})

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

utils.command = function(command)
  if type(command) == "table" then
    if type(command[#command]) == "function" then
      command[#command] = func2str(command[#command], false)
    end
    command = table.concat(command, " ")
  end
  cmd("com!" .. command)
end

utils.eval = function(inStr)
  return assert(load(inStr))()
end
