local M = {}

---@class PluginOptions
---@field root string
---@field dev_root string
M.options = {}

---@type PluginOptions
local default = {
  root = vim.fn.stdpath("data") .. "/site/pack/jetpack/opt",
  dev_root = vim.fs.normalize("~/plugin"),
}

---@param opts? PluginOptions
function M.setup(opts)
  M.options = vim.tbl_extend("force", {}, default, M.options, opts or {})
end

M.setup()

return M
