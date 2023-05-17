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

return M
