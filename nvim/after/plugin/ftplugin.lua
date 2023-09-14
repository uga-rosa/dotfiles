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

ft_event.python = rc.call_with(set_indent, 4, false)

ft_event.qf = rc.call_with(set_indent, 4, true)
ft_event.go = rc.call_with(set_indent, 4, true)

ft_event.help = rc.call_with(set_indent, 8, true)

ft_event.vim = function()
  vim.keymap.set("n", "gd", "<Cmd>call vimrc#vim#gd()<CR>", { buffer = true })
end

local function find_first_existing_file_path(paths)
  return vim.iter(paths):map(vim.fs.normalize):find(vim.fs.isfile)
end

ft_event.lua = function()
  local stylua_toml = find_first_existing_file_path({
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

ft_event.typescript = function(ev)
  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = ev.buf,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line_before_cursor = line:sub(1, cursor[2])
      if vim.endswith(line_before_cursor, "${") then
        vim.api.nvim_feedkeys(vim.keycode('<Cmd>normal sr"`<CR>'), "n", false)
        vim.schedule(function()
          vim.api.nvim_win_set_cursor(0, cursor)
        end)
      end
    end,
  })
end
