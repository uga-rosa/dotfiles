local M = {}

local fn = vim.fn
local api = vim.api

--@param str string
--@param delim string
--@return array-like table
local split = function(str, delim)
  delim = delim or " "
  local res = {}
  for i in str:gmatch(("[^%s]+"):format(delim)) do
    res[#res + 1] = i
  end
  return res
end

local rep = function(str, delim, count)
  local res = delim
  for _ = 1, count do
    res = res .. str .. delim
  end
  return res
end

M.make = function()
  local size = fn.input("Input table size (line, column): ")
  size = split(size, " ,/")
  local line, col = tonumber(size[1]), tonumber(size[2])
  local text = {}
  for i = 1, line + 1 do
    if i == 2 then
      text[#text + 1] = rep("---", "|", col)
    else
      text[#text + 1] = rep("   ", "|", col)
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
      vim.cmd("normal! f" .. sep .. "l")
    else
      vim.cmd("normal! j0l")
    end
  elseif dir == -1 then
    local search_target = line:sub(1, col)
    if search_target:match(("%s.+%s"):format(sep, sep)) then
      vim.cmd("normal! 2F" .. sep .. "l")
    else
      vim.cmd("normal! k$F" .. sep .. "l")
    end
  end
end

M.setup = function()
  vim.cmd("command! MakeTable lua require('myplug.table').make()")
  local map = utils.map
  map("i", "<tab>", '<cmd>lua require("myplug.table").jump(1)<cr>')
  map("i", "<S-tab>", '<cmd>lua require("myplug.table").jump(-1)<cr>')
end

return M
