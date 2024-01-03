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

---@param rocks string[]
---@return string[]
local function get_rock_path(rocks)
  local root = "/usr/local/share/lua/5.1/"
  local paths = {}
  for _, rock in ipairs(rocks) do
    local path = root .. rock
    if vim.bool_fn.isdirectory(path) then
      table.insert(paths, path)
    else
      vim.notify("Invalid rock name: " .. rock)
    end
  end
  return paths
end

---@param plugins string[]
---@param rocks string[]
---@return string[]
local function library(plugins, rocks)
  local paths = vim.list_extend(get_plugin_paths(plugins), get_rock_path(rocks))
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
        library = library({ "lazy.nvim", "nvim-insx" }, { "vusted" }),
        checkThirdParty = false,
      },
      hint = {
        enable = false,
      },
    },
  },
}
