local M = {}

local mappings = require("filetype.mappings")

local function setf(ft)
  if vim.fn.did_filetype() == 0 then
    vim.bo.filetype = ft
    return true
  end
  return false
end

local function set_filetype(ft)
  if type(ft) == "function" then
    ft = ft()
  end
  if type(ft) == "string" then
    return setf(ft)
  end
  return false
end

if vim.g.ft_ignore_pat == nil then
  vim.g.ft_ignore_pat = [[\.\(Z\|gz\|bz2\|zip\|tgz\)$]]
end
local ft_ignore_pat = vim.regex(vim.g.ft_ignore_pat)

local function analyze_shebang()
  local fstline = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
  if fstline then
    return fstline:match("#!%s*/usr/bin/env%s+(%a+)$") or fstline:match("#!%s*/.*/(%a+)$")
  end
end

function M.resolve()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    return
  end
  local ext = filename:match("^.*%.(.*)$")

  if ext then
    local filetype = mappings.extensions[ext] or mappings.function_extensions[ext]
    if filetype and set_filetype(filetype) then
      return
    end
  end

  local literal = mappings.literal[filename] or mappings.function_simple[filename]
  if literal and set_filetype(literal) then
    return
  end

  local fullpath = vim.fn.expand("%:p")

  for ends, ft in pairs(mappings.endswith) do
    if vim.endswith(fullpath, ends) and set_filetype(ft) then
      return
    end
  end

  if not ft_ignore_pat:match_str(fullpath) then
    for regex, ft in pairs(mappings.pattern) do
      if fullpath:find(regex) and set_filetype(ft) then
        return
      end
    end
  end

  if ext and set_filetype(ext) then
    return
  end

  local shebang = analyze_shebang()
  if shebang then
    shebang = mappings.shebang[shebang] or shebang
    set_filetype(shebang)
  end
end

function M.override(opts)
  for name, t in pairs(opts) do
    for k, v in pairs(t) do
      mappings[name][k] = v
    end
  end
end

return M
