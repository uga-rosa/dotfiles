_G.myutils.sum = function(startline, lastline)
  local lines = vim.api.nvim_buf_get_lines(0, startline - 1, lastline, true)
  local sum = 0
  for _, v in ipairs(lines) do
    local n = tonumber(v)
    if n then
      sum = sum + n
    end
  end
  return sum
end

_G.myutils.mean = function(startline, lastline)
  local sum = myutils.sum(startline, lastline)
  return sum / (lastline - startline + 1)
end
