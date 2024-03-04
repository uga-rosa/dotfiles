local utils = require("rc.utils")
local config_dir = vim.fn.stdpath("config") --[[@as string]]
local dev_root = vim.fs.normalize("~/plugin")

---@class PluginLoader
---@field _depends PluginSpecBase[]
---@field _hook table<string, function>
local Loader = {
  _depends = {},
  _hook = {},
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

local hook_template = table.concat({
  "lua if require('jetpack').tap(%q) then",
  "  require('rc.conf.plugin.loader')._hook[%q]()",
  "end",
}, " ")

---@param hook_name string
---@param pkg_name string
---@param value? string | function
local function create_hook(hook_name, pkg_name, value)
  if value == nil then
    return
  end
  local key = hook_name .. pkg_name
  if type(value) == "function" then
    Loader._hook[key] = value
  else
    Loader._hook[key] = assert(load(value))
  end
  return hook_template:format(pkg_name, key)
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

  local pkg_name = get_name(spec)
  ---@type JetpackOptions
  local opts = utils.partial(
    spec,
    { "cmd", "event", "ft", "branch", "tag", "commit", "rtp", "build", "frozen", "path" }
  )
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
        table.insert(Loader._depends, depend_spec)
      end
      table.insert(opts.depends, depend_spec[1])
    end
  end

  local repo = spec[1]
  if spec.dev then
    repo = vim.fs.joinpath(dev_root, get_name(spec))
  end
  if vim.tbl_isempty(opts) then
    opts = vim.empty_dict()
  end
  vim.fn["jetpack#add"](repo, opts)

  if spec.import then
    local root = vim.fs.normalize(config_dir .. "/lua/" .. spec.import:gsub("%.", "/"))
    Loader.load_dir(root)
  end
end

---@param root string
function Loader.load_dir(root)
  for name, type in vim.fs.dir(root) do
    local path = vim.fs.joinpath(root, name)
    local modname = path:gsub(".*/lua/", ""):gsub("%.lua$", ""):gsub("/", ".")
    if type == "file" and name ~= "init.lua" then
    elseif type == "directory" and vim.fs.isfile(vim.fs.joinpath(path, "init.lua")) then
      modname = modname .. ".init"
    else
      goto continue
    end
    local specs = utils.to_list(require(modname))
    for _, spec in ipairs(specs) do
      Loader.load_plugin(spec)
    end

    ::continue::
  end
end

---@param root string
function Loader.run(root)
  vim.fn["jetpack#begin"]()

  vim.fn["jetpack#add"]("tani/vim-jetpack", { opt = true })

  Loader.load_dir(root)

  for _, depend_spec in ipairs(Loader._depends) do
    Loader.load_plugin(depend_spec)
  end

  vim.fn["jetpack#end"]()
end

return Loader
