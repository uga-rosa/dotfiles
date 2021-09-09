local M = {}

local fn = vim.fn
local api = vim.api

local us = utils.string

M.make = function()
  local size = fn.input("Input table size (line, column): ")
  size = us.split(size, " ,")
  local line, col = tonumber(size[1]), tonumber(size[2])
  local text = {}
  for i = 1, line + 1 do
    if i == 2 then
      text[#text + 1] = us.rep(" --- ", "|", col)
    else
      text[#text + 1] = us.rep("     ", "|", col)
    end
  end
  api.nvim_buf_set_lines(0, fn.line("."), fn.line("."), true, text)
end

--@param dir (int): 1 for normal direction, -1 for opposite direction.
M.jump = function(dir)
  local line = fn.getline(".")
  local col = fn.col(".")
  local sep = "|"

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

local table_range = function(start, dir, sep)
  while true do
    if not fn.getline(start + dir):match(sep) then
      break
    end
    start = start + dir
  end
  return start
end

local max_strlen = function(arr, dim)
  local res = {}
  if dim == 1 then
  elseif dim == 2 then
  end
  return res
end

M.format = function()
  local sep = "|"
  local line_num = tonumber(fn.line("."))
  local line = fn.getline(line_num)

  if not line:match(sep) then
    return
  end

  local start = table_range(line_num, -1, sep)
  local last = table_range(line_num, 1, sep)

  local tables = api.nvim_buf_get_lines(0, start - 1, last, true)
  local table_split = {}
  for _, v in ipairs(tables) do
    table_split[#table_split + 1] = vim.tbl_map(function(w)
      return trim(w)
    end, split(
      v,
      sep
    ))
  end
  for i, v in ipairs(transposition(table_split)) do
  end
end

M.enable = function()
  local map = utils.map
  map("i", "<tab>", '<cmd>lua require("myplug.table").jump(1)<cr>')
  map("i", "<S-tab>", '<cmd>lua require("myplug.table").jump(-1)<cr>')
end

M.disable = function()
  vim.api.nvim_del_keymap("i", "<tab>")
  vim.api.nvim_del_keymap("i", "<S-tab>")
end

M.setup = function()
  vim.cmd("command! TableMake lua require('myplug.table').make()")
  vim.cmd("command! -range TableFormat lua require('myplug.table').format()")
  vim.cmd("command! TableMapEnable lua require('myplug.table').enable()")
  vim.cmd("command! TableMapDisable lua require('myplug.table').disable()")
end

return M
