local M = {}

local fn = vim.fn
local api = vim.api

local map = utils.map
local augroup = utils.augroup

local sep = "|"

local split = function(str, delim)
  delim = delim or " "
  local res = {}
  for i in str:gmatch(("[^%s]+"):format(delim)) do
    res[#res + 1] = i
  end
  return res
end

M.make = function()
  local size = fn.input("Input table size (line, column): ")
  size = split(size, " ,")
  assert(#size == 2, "Input two number")
  local line, col = tonumber(size[1]), tonumber(size[2])
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

--@param dir (int): 1 for normal direction, -1 for opposite direction.
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
      if i == 1 then
        res[j] = #u
      else
        res[j] = res[j] < #u and #u or res[j]
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
  vim.cmd("command! TableMake lua require('myplug.table').make()")
  vim.cmd("command! -range TableFormat lua require('myplug.table').format()")
  M.mapping()
  augroup({
    table = {
      {
        "FileType",
        "markdown",
        function()
          M.mapping()
        end,
      },
    },
  })
end

return M
