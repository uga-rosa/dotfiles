Log = {}
Log.__index = Log

function Log.new()
  return setmetatable({}, Log)
end

---@param opts table
function Log:start(opts)
  if not opts.path then
    opts.name = "default"
  end
  local root = vim.fs.normalize(vim.fn.stdpath("data") .. "/log/")
  if not vim.fs.isdir(root) then
    vim.fn.mkdir(root, "p")
  end
  local path = vim.fs.normalize(root .. "/" .. opts.name)
  self.fd = assert(vim.uv.fs_open(path, "a", 511))
end

function Log:log(...)
  if not self.fd then
    self:start({})
  end
  local data = ""
  for _, e in ipairs({ ... }) do
    data = data .. vim.inspect(e) .. "\n"
  end
  assert(vim.uv.fs_write(self.fd, data))
end

function Log:on_close()
  if self.fd then
    vim.uv.fs_close(self.fd)
  end
  self.fd = nil
end
