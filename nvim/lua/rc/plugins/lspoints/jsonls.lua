return {
  attach = function()
    vim.fn["lspoints#attach"]("jsonls", {
      cmd = { "vscode-json-language-server", "--stdio" },
    })
  end,
}
