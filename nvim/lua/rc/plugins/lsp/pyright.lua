local helper = require("rc.helper.lsp")
local formatter = require("rc.helper.formatter")

helper.on_attach("pyright", function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    formatter.stdin("black -")
  end, {})
end)

return {}
