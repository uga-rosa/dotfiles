local M = {}

local mappings = require("filetype.mappings")

local function set_filetype(name)
  if type(name) == "string" then
    vim.bo.filetype = name
    return true
  elseif type(name) == "function" then
    local n = name()
    if type(n) == "string" then
      vim.bo.filetype = n
      return true
    end
  end
  return false
end

local function is_frozen(path)
  local t = { ".Z", ".gz", ".bz2", ".zip", ".tgz" }
  for i = 1, #t do
    if vim.endswith(path, t[i]) then
      return true
    end
  end
  return false
end

local function try_regex(path, maps, star_set)
  if star_set and is_frozen(path) then
    return false
  end
  for regex, ft in pairs(maps) do
    if path:find(regex) then
      if set_filetype(ft) then
        return true
      end
    end
  end
  return false
end

local function analyze_shebang()
  local fstline = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
  if fstline then
    return fstline:match("#!%s*/usr/bin/env%s+(%a+)$") or fstline:match("#!%s*/.*/(%a+)$")
  end
end

function M.resolve()
  local fullpath = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e")

  if filename == "" then
    return
  end

  if ext then
    local filetype = mappings.extensions[ext] or mappings.function_extensions[ext]
    if filetype then
      set_filetype(filetype)
      return
    end
  end

  local literal = mappings.literal[filename] or mappings.function_simple[filename]
  if literal then
    set_filetype(literal)
  end

  for ends, ft in pairs(mappings.endswith) do
    if vim.endswith(fullpath, ends) then
      set_filetype(ft)
    end
  end

  if try_regex(fullpath, mappings.complex) then
    return
  end

  if try_regex(fullpath, mappings.star_sets, true) then
    return
  end

  if ext then
    set_filetype(ext)
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
