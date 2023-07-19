local M = {}

---Register callback function on LspAttach
---@param name string|nil If nil, global
---@param callback fun(client:  table, bufnr: integer)
function M.on_attach(name, callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if name == nil or client.name == name then
        callback(client, bufnr)
      end
    end,
  })
end

M.root_dir = {
  node = { "tsconfig.json", "package.json", "jsconfig.json" },
  deno = { "deno.json", "deno.jsonc", "denops", ".git" },
}

M.typescriptInlayHints = {
  parameterNames = {
    enabled = "literals",
    suppressWhenArgumentMatchesName = true,
  },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = false },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

---@param fname string
---@return boolean
function M.in_node_repo(fname)
  return require("lspconfig").util.root_pattern(unpack(M.root_dir.node))(fname) ~= nil
end

return M