local M = {}

local fn = vim.fn
local api = vim.api

local map = myutils.map
local command = myutils.command
local augroup = myutils.augroup

local sep = "|"

local split = function(str, delim)
  delim = delim or " "
  local res = {}
  for i in str:gmatch(("[^%s]+"):format(delim)) do
    res[#res + 1] = i
  end
  return res
end

M.make = function(...)
  local args = { ... }

  local line, col = (function()
    if #args == 2 then
      return tonumber(args[1]), tonumber(args[2])
    elseif #args == 0 then
      local input = fn.input("Input table size (line, column): ")
      input = split(input, " ,")
      if #input == 2 then
        return tonumber(input[1]), tonumber(input[2])
      else
        error("Only two arguments.")
      end
    else
      error("Only two arguments.")
    end
  end)()

  local text = {}
  for i = 1, line + 1 do
    if i == 2 then
      text[#text + 1] = sep .. string.rep(" --- ", col, sep) .. sep
    else
      text[#text + 1] = sep .. string.rep("     ", col, sep) .. sep
    end
  end
  api.nvim_buf_set_lines(0, fn.line("."), fn.line("."), true, text)
end

---Jump between cells.
---dir == 1 mean normal direction, dir == -1 mean opposite direction.
---@param dir integer
M.jump = function(dir)
  local line = fn.getline(".")
  local col = fn.col(".")

  if dir == 1 then
    local search_target = line:sub(col)
    if search_target:match(("%s.+%s"):format(sep, sep)) then
      vim.cmd("normal! f" .. sep .. "2l")
    else
      vim.cmd("normal! j02l")
    end
  elseif dir == -1 then
    local search_target = line:sub(1, col)
    if search_target:match(("%s.+%s"):format(sep, sep)) then
      vim.cmd("normal! 2F" .. sep .. "2l")
    else
      vim.cmd("normal! k$F" .. sep .. "2l")
    end
  end
end

local table_range = function(start, dir)
  while true do
    if not fn.getline(start + dir):match(sep) then
      break
    end
    start = start + dir
  end
  return start
end

local trim = function(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

local max_col_len = function(arr)
  local res = {}
  for i, v in ipairs(arr) do
    for j, u in ipairs(v) do
      local width = fn.strwidth(u)
      if i == 1 then
        res[j] = width
      else
        res[j] = res[j] < width and width or res[j]
      end
    end
  end
  return res
end

local ljust = function(str, num, is2)
  if is2 then
    local bars = string.rep("-", num - 2)
    return str:gsub("^(.)%-*(.)$", "%1" .. bars .. "%2")
  else
    return str .. string.rep(" ", num - #str)
  end
end

M.format = function()
  local line_num = tonumber(fn.line("."))
  local line = fn.getline(line_num)

  if not line:match(sep) then
    return
  end

  local start = table_range(line_num, -1)
  local last = table_range(line_num, 1)

  local tables = api.nvim_buf_get_lines(0, start - 1, last, true)

  local table_split = vim.tbl_map(function(v)
    return vim.tbl_map(function(w)
      return trim(w)
    end, split(v, sep))
  end, tables)

  local col_len = max_col_len(table_split)

  local formatted = {}
  for i, v in ipairs(table_split) do
    local temp = {}
    for j, u in ipairs(v) do
      temp[j] = " " .. ljust(u, col_len[j], i == 2) .. " "
    end
    formatted[i] = sep .. table.concat(temp, sep) .. sep
  end

  api.nvim_buf_set_lines(0, start - 1, last, true, formatted)
end

M.mapping = function()
  map("i", "<tab>", function(fallback)
    if fn.getline("."):match(sep) then
      M.jump(1)
    else
      fallback()
    end
  end, "buffer")

  map("i", "<S-tab>", function(fallback)
    if fn.getline("."):match(sep) then
      M.jump(-1)
    else
      fallback()
    end
  end, "buffer")
end

M.setup = function()
  command({ "-nargs=*", "TableMake", M.make })
  command({ "TableFormat", M.format })
  M.mapping()
  augroup({
    table = {
      {
        "FileType",
        "markdown",
        M.mapping,
      },
    },
  })
end

return M
