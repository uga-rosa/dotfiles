local helper = require("rc.helper.lsp")
local formatter = require("rc.helper.formatter")

helper.on_attach("lua_ls", function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    local cmd = ("stylua -f %s -"):format(vim.fs.normalize("~/.config/stylua.toml"))
    if uga.fs.isfile("stylua.toml") or uga.fs.isfile(".stylua.toml") then
      cmd = "stylua -"
    end
    formatter.stdin(cmd)
  end, {})
end)

---@param names string[]
---@return string[]
local function get_plugin_paths(names)
  local plugins = require("lazy.core.config").plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end

---@param plugins string[]
---@return string[]
local function library(plugins)
  local paths = get_plugin_paths(plugins)
  table.insert(paths, "/usr/local/share/lua/5.1")
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end

return {
  settings = {
    Lua = {
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
        library = library({ "lazy.nvim", "nvim-insx" }),
        checkThirdParty = "Disable",
      },
      hint = {
        enable = false,
      },
    },
  },
}
