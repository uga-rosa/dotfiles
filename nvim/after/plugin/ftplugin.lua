local rc = require("rc.utils")

local function set_formatoptions()
  for v in vim.gsplit("tcro", "") do
    vim.opt_local.formatoptions:remove(v)
  end
  vim.opt_local.formatoptions:prepend("mMl")
end

---@param tab_size integer
---@param is_hard_tab? boolean
local function set_indent(tab_size, is_hard_tab)
  vim.opt_local.expandtab = not is_hard_tab
  vim.opt_local.tabstop = tab_size
  vim.opt_local.softtabstop = tab_size
  vim.opt_local.shiftwidth = tab_size
end

---@type table<string, function> Keys are file types, values are callbacks.
local ft_event = {}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my-ftplugin", {}),
  callback = function(ev)
    local ft = ev.match
    if ft_event[ft] then
      ft_event[ft](ev)
    end
    set_formatoptions()
  end,
})

ft_event.python = rc.bind(set_indent, 4, false)

ft_event.qf = rc.bind(set_indent, 4, true)
ft_event.go = rc.bind(set_indent, 4, true)

ft_event.help = rc.bind(set_indent, 8, true)

ft_event.toml = rc.bind(set_indent, 2, true)

local foldlevel = 0
local valid_marker = {}

---@param lnum integer
---@return integer
function _G.markdown_foldexpr(lnum)
  if lnum == 1 then
    foldlevel = 0
  end
  local current_line = vim.fn.getline(lnum) --[[@as string]]
  local start_marker = current_line:match("^(:*:::)details")
  if start_marker then
    foldlevel = foldlevel + 1
    valid_marker[start_marker] = true
  else
    local end_marker = current_line:match("^:*:::")
    if valid_marker[end_marker] then
      valid_marker[end_marker] = false
      foldlevel = foldlevel - 1
      return foldlevel + 1
    end
  end
  return foldlevel
end

ft_event.markdown = function()
  set_indent(2, false)
  vim.opt_local.foldenable = true
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr(v:lnum)"
end

ft_event.vim = function()
  vim.keymap.set("n", "gd", "<Cmd>call vimrc#vim#gd()<CR>", { buffer = true })
end

---@param paths string[]
---@return string?
local function find_first_existing_file_path(paths)
  return vim.iter(paths):map(vim.fs.normalize):find(uga.fs.isfile)
end

ft_event.lua = function()
  local stylua_toml_path = find_first_existing_file_path({
    "stylua.toml",
    ".stylua.toml",
    "~/.config/stylua.toml",
  })

  if stylua_toml_path then
    local raw = uga.fs.read(stylua_toml_path)
    local stylua_toml = vim.fn["rc#toml#parse"](raw)

    local tab_size = stylua_toml.indent_width or 2
    local is_hard_tab = stylua_toml.indent_type == "Tabs"
    set_indent(tab_size, is_hard_tab)
  end
end
