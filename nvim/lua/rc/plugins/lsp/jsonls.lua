local helper = require("rc.helper.lsp")
local formatter = require("rc.helper.formatter")

helper.on_attach("jsonls", function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    formatter.stdin("deno fmt --ext json -")
  end, {})
end)

return {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
