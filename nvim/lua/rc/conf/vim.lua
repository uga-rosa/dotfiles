---@param path string
---@return table|nil
local function get_stat(path)
  ---@type string|nil
  local fullpath = vim.uv.fs_realpath(vim.fs.normalize(path))
  return fullpath and vim.loop.fs_stat(fullpath)
end

---Returns whether path exists or not.
---In case of symlink, refer to the attribute of the link destination.
---@param path string
---@return boolean
function vim.fs.exists(path)
  local stat = get_stat(path)
  return stat ~= nil
end

---Returns whether path indicates a file.
---In case of symlink, refer to the attribute of the link destination.
---@param path string
---@return boolean
function vim.fs.isfile(path)
  local stat = get_stat(path)
  return stat ~= nil and stat.type == "file"
end

---Returns whether path indicates a directory.
---In case of symlink, refer to the attribute of the link destination.
---@param path string
---@return boolean
function vim.fs.isdir(path)
  local stat = get_stat(path)
  return stat ~= nil and stat.type == "directory"
end

---@param fname string
---@return string
function vim.fs.read(fname)
  local fd = assert(vim.uv.fs_open(fname, "r", 292)) -- 0444
  local stat = assert(vim.uv.fs_fstat(fd))
  local buffer = assert(vim.uv.fs_read(fd, stat.size, 0))
  assert(vim.uv.fs_close(fd))
  return buffer
end

---@param fname string
---@param data string|string[]
function vim.fs.write(fname, data)
  local fd = assert(vim.uv.fs_open(fname, "w", 438))
  assert(vim.uv.fs_write(fd, data))
  vim.uv.fs_close(fd)
end
