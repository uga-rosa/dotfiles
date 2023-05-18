local M = {}

---@param path string?
---@return string? root_dir
function M.find_root(path)
  path = path or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return vim
    .iter(vim.fs.find(".git", {
      upward = true,
      path = path,
    }))
    :map(vim.fs.dirname)
    :totable()[1]
end

---@param package_name string
---@param key unknown
---@param value unknown
function M.package_set(package_name, key, value)
  local module = (package.preload[package_name] or function()
    return {}
  end)()
  module[key] = value
  package.preload[package_name] = function()
    return module
  end
end

return M
