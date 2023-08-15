local M = {}

M.sources = {
  default = { "vsnip", "nvim-lsp", "buffer", "dictionary" },
  skkeleton = { "skkeleton" },
  lua = { "vsnip", "nvim-lua", "nvim-lsp", "buffer", "dictionary" },
}

function M.patch_global(...)
  vim.fn["ddc#custom#patch_global"](...)
end

function M.patch_filetype(...)
  vim.fn["ddc#custom#patch_filetype"](...)
end

function M.patch_buffer(...)
  vim.fn["ddc#custom#patch_buffer"](...)
end

---@param type "source" | "filter"
---@param alias string
---@param base string
function M.alias(type, alias, base)
  vim.fn["ddc#custom#alias"](type, alias, base)
end

---@param fun function
---@return string
function M.register(fun)
  return vim.fn["denops#callback#register"](fun)
end

return M
