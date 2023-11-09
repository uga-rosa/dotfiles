return {
  attach = function()
    vim.fn["lspoints#attach"]("taplo", {
      cmd = { "taplo", "lsp", "stdio", "--default-schema-catalogs" },
    })
  end,
}
