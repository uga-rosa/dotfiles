local helper = require("rc.helper.lsp")
local formatter = require("rc.helper.formatter")

helper.on_attach("lua_ls", function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    local cmd = ("stylua -f %s -"):format(vim.fs.normalize("~/.config/stylua.toml"))
    if vim.fs.isfile("stylua.toml") or vim.fs.isfile(".stylua.toml") then
      cmd = "stylua -"
    end
    formatter.stdin(cmd)
  end, {})
end)

---@return string[]
local function library()
  local paths = vim.api.nvim_get_runtime_file("lua", true)
  table.insert(paths, "/usr/local/share/lua/5.1")
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "./lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end

return {
  settings = {
    Lua = {
      diagnostics = {
        disable = {
          "duplicate-set-field",
          "duplicate-doc-alias",
          "duplicate-doc-field",
        },
      },
      format = {
        -- Use stylua
        enable = false,
      },
      semantic = {
        enable = false,
      },
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = library(),
        checkThirdParty = "Disable",
      },
      hint = {
        enable = false,
      },
    },
  },
}
