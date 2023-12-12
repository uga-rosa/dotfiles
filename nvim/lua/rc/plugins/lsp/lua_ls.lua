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

---@param plugins string[]
---@return string[]
local function get_plugin_path(plugins)
  local paths = {}
  local options = require("lazy.core.config").options
  local dev_root = options.dev.path
  local root = options.root
  for _, plugin in ipairs(plugins) do
    local dev_path = vim.fs.joinpath(dev_root, plugin)
    local path = vim.fs.joinpath(root, plugin)
    if vim.fs.isdir(vim.fs.joinpath(dev_path, "lua")) then
      table.insert(paths, dev_path)
    elseif vim.fs.isdir(vim.fs.joinpath(path, "lua")) then
      table.insert(paths, path)
    else
      vim.notify("Invalid plugin name: " .. plugin)
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
  local paths = vim.list_extend(get_plugin_path(plugins), get_rock_path(rocks))
  table.insert(paths, vim.fn.stdpath("config"))
  table.insert(paths, "/usr/local/share/nvim/runtime")
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
      diagnostics = {
        globals = {
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each",
          "setup",
          "teardown",
        },
      },
      semantic = {
        enable = false,
      },
      runtime = {
        version = "LuaJIT",
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = library({ "lazy.nvim", "nvim-insx" }, { "vusted" }),
        checkThirdParty = false,
      },
      hint = {
        enable = true,
      },
    },
  },
}
