local helper = require("rc.helper.lsp")
local formatter = require("rc.helper.formatter")

return {
  attach = function(bufnr)
    vim.fn["lspoints#attach"]("pyright", {
      cmd = { "pyright-langserver", "--stdio" },
    })

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
      formatter.stdin("black -")
    end, {})
  end,
}
