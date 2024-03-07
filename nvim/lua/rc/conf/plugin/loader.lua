local utils = require("rc.utils")
local options = require("rc.conf.plugin.config").options

---@class PluginLoader
---@field public plugins table<string, PluginSpecBase>
---@field private depends PluginSpecBase[]
---@field private hook table<string, function>
local Loader = {
  plugins = {},
  depends = {},
  hook = {},
}

---@param spec PluginSpecBase
---@return string
local function get_name(spec)
  return vim.fn.fnamemodify(spec[1], ":t")
end

---@param spec PluginSpecBase
---@return boolean
local function is_lazy(spec)
  return not not (spec.lazy or spec.keys or spec.cmd or spec.event or spec.ft)
end

---@param x? boolean | fun(): boolean
---@param default boolean
---@return boolean
local function is_truthy(x, default)
  if x == nil then
    return default or true
  end
  if type(x) == "boolean" then
    return x
  end
  return x()
end

---@param spec PluginSpecBase
local function set_keys(spec)
  local key_specs = utils.to_list(spec.keys) --[[@as PluginKeySpec[] ]]
  for _, key_spec in ipairs(key_specs) do
    local modes = utils.to_list(utils.get(key_spec, "mode", "n")) --[[@as string[] ]]
    local lhs = utils.get(key_spec, 1)
    local rhs = utils.get(key_spec, 2)
    local opts = utils.partial(
      key_spec,
      { "buffer", "remap", "desc", "nowait", "silent", "script", "uniq", "expr" }
    )
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, lhs, function()
        -- Remove the mappings immediately to prevent recursive mappings
        pcall(vim.keymap.del, mode, lhs)
        -- Load plugin
        vim.fn["jetpack#load"](get_name(spec))
        -- Set real mappings
        vim.keymap.set(mode, lhs, rhs, opts)
        if vim.endswith(mode, "a") then
          -- trigger abbreviation
          lhs = lhs .. "<C-]>"
        end
        vim.api.nvim_feedkeys(vim.keycode("<Ignore>" .. lhs), "mi", false)
      end, {
        desc = opts.desc,
        nowait = opts.nowait,
        -- expr is need to make operator pending mappings work
        expr = true,
        buffer = opts.buffer,
      })
    end
  end
end

---@param hook_name string
---@param pkg_name string
---@param value? string | function
local function create_hook(hook_name, pkg_name, value)
  if value == nil then
    return
  end
  local key = hook_name .. pkg_name
  if type(value) == "function" then
    Loader.hook[key] = value
  else
    Loader.hook[key] = assert(load(value))
  end
  return ("lua require'rc.conf.plugin.loader'.hook[%q]()"):format(key)
end

---@param spec PluginSpec
function Loader.load_plugin(spec)
  if type(spec) == "string" then
    spec = { spec }
  end
  ---@cast spec PluginSpecBase
  if not is_truthy(spec.enabled, true) then
    return
  end
  if Loader.plugins[spec[1]] then
    return
  end
  Loader.plugins[spec[1]] = spec

  local pkg_name = get_name(spec)
  ---@type JetpackOptions
  local opts = utils.partial(spec, {
    "cmd",
    "event",
    "ft",
    "branch",
    "tag",
    "commit",
    "rtp",
    "build",
    "frozen",
    "path",
    "before",
    "after",
  })
  opts.opt = spec.lazy
  opts.hook_add = create_hook("init", pkg_name, spec.init)
  opts.hook_source = create_hook("setup", pkg_name, spec.setup)
  opts.hook_post_source = create_hook("config", pkg_name, spec.config)

  if spec.keys then
    set_keys(spec)
    opts.opt = true
  end

  if spec.dependencies then
    opts.depends = {}
    for _, depend_spec in ipairs(utils.to_list(spec.dependencies)) do
      if type(depend_spec) == "string" then
        depend_spec = { depend_spec }
      end
      ---@cast depend_spec PluginSpecBase
      if depend_spec[1]:find("/") then
        if is_lazy(spec) then
          depend_spec.lazy = true
        end
        table.insert(Loader.depends, depend_spec)
      end
      table.insert(opts.depends, depend_spec[1])
    end
  end

  local repo = spec[1]
  if spec.dev then
    repo = vim.fs.joinpath(options.dev_root, get_name(spec))
  end
  if vim.tbl_isempty(opts) then
    opts = vim.empty_dict()
  end
  vim.fn["jetpack#add"](repo, opts)

  if spec.import then
    Loader.load_dir(spec.import)
  end
end

---@param import string
function Loader.load_dir(import)
  local pattern = "lua/" .. import:gsub("%.", "/")
  local paths = {}
  vim.list_extend(paths, vim.api.nvim_get_runtime_file(pattern .. "/*.lua", true))
  vim.list_extend(paths, vim.api.nvim_get_runtime_file(pattern .. "/*/init.lua", true))
  for _, path in ipairs(paths) do
    local modname = path:gsub(".*/lua/", ""):gsub("%.lua$", ""):gsub("/", ".")
    local specs = utils.to_list(require(modname))
    for _, spec in ipairs(specs) do
      Loader.load_plugin(spec)
    end
  end
end

---@param import string
function Loader.run(import)
  vim.fn["jetpack#begin"]()

  vim.fn["jetpack#add"]("tani/vim-jetpack", { opt = true })

  Loader.load_dir(import)

  for _, depend_spec in ipairs(Loader.depends) do
    Loader.load_plugin(depend_spec)
  end

  vim.fn["jetpack#end"]()
end

return Loader
