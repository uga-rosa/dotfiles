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

ft_event.python = rc.createWrapper(set_indent, 4, false)
ft_event.toml = rc.createWrapper(set_indent, 4, false)

ft_event.qf = rc.createWrapper(set_indent, 4, true)
ft_event.go = rc.createWrapper(set_indent, 4, true)

ft_event.help = rc.createWrapper(set_indent, 8, true)

ft_event.lua = function()
  local function findFirstExistingFilePath(paths)
    return vim.iter(paths):map(vim.fs.normalize):find(vim.fs.isfile)
  end

  local stylua_toml = findFirstExistingFilePath({
    "stylua.toml",
    ".stylua.toml",
    "~/.config/stylua.toml",
  })

  if stylua_toml then
    local tab_size, is_hard_tab = 2, false
    for line in io.lines(stylua_toml) do
      if vim.startswith(line, "indent_width") then
        tab_size = tonumber(line:match("%d+")) or 2
      elseif vim.startswith(line, "indent_type") then
        is_hard_tab = not not line:find("Tabs")
      end
    end

    set_indent(tab_size, is_hard_tab)
  end
end

ft_event.toml = function()
  vim.opt_local.foldenable = true
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "vimrc#fold_toml(v:lnum)"
end
