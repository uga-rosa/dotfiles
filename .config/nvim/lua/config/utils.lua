utils = {}
local api, cmd = vim.api, vim.cmd

utils.lua2vim = function(func)
  if not _G.myluafunc then
    _G.myluafunc = setmetatable({}, {
      __call = function(self, idx)
        return self[idx]()
      end,
    })
  end
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  return "v:lua.myluafunc(" .. idx .. ")"
end

-- modes:   mode (string or array)
-- befores: {lhs} (string or array)
-- after:   {rhs} (string or function)
-- opts:    option. including "buffer" (string or array)
utils.map = function(modes, befores, after, opts)
  modes = type(modes) == "string" and { modes } or modes
  befores = type(befores) == "string" and { befores } or befores
  local bufflag = false
  if type(opts) == "nil" then
    opts = {}
  else
    opts = type(opts) == "string" and { opts } or opts
    for key, opt in ipairs(opts) do
      if opt == "buffer" then
        bufflag = true
      else
        opts[opt] = true
      end
      opts[key] = nil
    end
  end
  if type(after) == "function" then
    after = utils.lua2vim(after)
    if not opts.expr then
      after = "<cmd>call " .. after .. "<cr>"
    end
  end
  for _, mode in ipairs(modes) do
    for _, before in ipairs(befores) do
      if bufflag then
        api.nvim_buf_set_keymap(0, mode, before, after, opts)
      else
        api.nvim_set_keymap(mode, before, after, opts)
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

utils.autocmd = function(autocmd)
  if type(autocmd[#autocmd]) == "function" then
    autocmd[#autocmd] = "call " .. utils.lua2vim(autocmd[#autocmd])
  end
  local command = table.concat(vim.tbl_flatten({ "au", autocmd }), " ")
  cmd(command)
end

utils.augroup = function(group, autocommands)
  cmd("augroup " .. group)
  cmd("au!")
  for _, autocmd in ipairs(autocommands) do
    utils.autocmd(autocmd)
  end
  cmd("augroup END")
end

local eval = function(inStr)
  return assert(load(inStr))()
end

-- opts' keys
-- config: Execute before the plugin loading (string or function).
--         But lua require will be resoloved without any problems.
-- check:  Flag of to load config (pcall(require, <value>)).
-- ft:     On-demand loading on filetype (string or array).
-- event:  On-demand loading on event (string).
utils.paq = function(opts)
  for _, v in ipairs(opts) do
    if type(v) == "table" then
      local config
      if v.config then
        if v.check then
          local check = type(v.check) == "string" and { v.check } or v.check
          for _, c in ipairs(check) do
            if not pcall(require, c) then
              goto continue
            end
          end
        end
        config = function()
          if type(v.config) == "function" then
            v.config()
          elseif type(v.config) == "string" then
            eval(v.config)
          end
        end
      end
      ::continue::

      if v.ft or v.event then
        v.opt = true
        local plugin_name = string.match(v[1], "^[^/]+/([^/]+)$")
        local timing
        if v.ft then
          local filetype = type(v.ft) == "table" and table.concat(v.ft, ",") or v.ft
          timing = "FileType " .. filetype
        elseif v.event then
          timing = v.event .. " *"
        end
        utils.autocmd({ timing, "packadd " .. plugin_name })
        if config then
          utils.autocmd({ timing, config })
        end
      elseif config then
        config()
      end
    end
  end
  require("paq")(opts)
end

utils.set = {}

-- self - arr
utils.set.diff = function(self, arr)
  local result = setmetatable({}, { __index = table })
  for _, v in ipairs(self) do
    if not vim.tbl_contains(arr, v) then
      result:insert(v)
    end
  end
  return result
end

utils.set.new = function(arr)
  return setmetatable(arr, { __index = utils.set })
end
