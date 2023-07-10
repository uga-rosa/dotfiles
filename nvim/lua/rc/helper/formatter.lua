local M = {}

---@param cmd string
function M.stdin(cmd)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local result = vim.system(vim.split(cmd, " "), { stdin = lines }):wait()
  if result.code > 0 then
    vim.notify("Failed to format", vim.log.levels.ERROR)
    return
  end
  local data = result.stdout:gsub("%s*$", "")
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(data, "\n"))
  vim.api.nvim_win_set_cursor(0, cursor)
end

--- `%f` is replaced by the filename
---@param cmd string
function M.tmp(cmd)
  local path = vim.api.nvim_buf_get_name(0)
  local tmpfile = os.tmpname()
  if not vim.uv.fs_copyfile(path, tmpfile) then
    vim.notify("Failed to copy", vim.log.levels.ERROR)
    return
  end
  cmd = cmd:gsub("%%f", tmpfile)
  local result = vim.system(vim.split(cmd, " ")):wait()
  if result.code > 0 then
    vim.notify("Failed to format", vim.log.levels.ERROR)
    return
  end
  local data = vim.fs.read(tmpfile):gsub("%s*$", "")
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(data, "\n"))
  vim.api.nvim_win_set_cursor(0, cursor)
end

return M
