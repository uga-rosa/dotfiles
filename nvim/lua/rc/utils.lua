local uv = vim.loop

---@type table<string, fun(...: unknown): boolean>
vim.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == "" then
        return false
      elseif type(v) == "table" and next(v) == nil then
        return false
      end
      return true
    end
  end,
})

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
end
