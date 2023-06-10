local uv = vim.loop

---@type table<string, fun(...: unknown): boolean>
vim.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      return vim.fn.empty(v) == 0
    end
  end,
})

---@param path string
---@return table|nil
local function get_stat(path)
  ---@type string|nil
  local fullpath = vim.loop.fs_realpath(vim.fs.normalize(path))
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
  local fd = assert(uv.fs_open(fname, "r", 292)) -- 0444
  local stat = assert(uv.fs_fstat(fd))
  local buffer = assert(uv.fs_read(fd, stat.size, 0))
  uv.fs_close(fd)
  return buffer
end

---@param fname string
---@param data string|string[]
function vim.fs.write(fname, data)
  local fd = assert(uv.fs_open(fname, "w", 438))
  assert(uv.fs_write(fd, data))
  uv.fs_close(fd)
end

local meta = {}

meta.__call = function(self, ...)
  local keys = rawget(self, "_keys")
  if #keys < 2 then
    vim.notify("invalid usage: you can use vim.fn instead", vim.log.levels.ERROR)
    return
  end
  return vim.fn[table.concat(keys, "#")](...)
end

meta.__index = function(self, key)
  local keys = rawget(self, "_keys") or {}
  return setmetatable({ _keys = vim.list_extend(keys, { key }) }, meta)
end

--- autoload function wrapper
--- vim.fa.foo.bar.baz() is same as vim.fn["foo#bar#baz"]\()
vim.af = setmetatable({}, meta)
