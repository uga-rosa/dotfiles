local M = {}

---@param tab_size? integer
---@param is_hard_tab? boolean
function M.set_indent(tab_size, is_hard_tab)
  tab_size = vim.F.if_nil(tab_size, 4)
  is_hard_tab = vim.F.if_nil(is_hard_tab, false)
  vim.opt_local.expandtab = not is_hard_tab
  vim.opt_local.tabstop = tab_size
  vim.opt_local.softtabstop = tab_size
  vim.opt_local.shiftwidth = tab_size
end

---@param cmd string|function
function M.keep_cursor(cmd)
  local win_id = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  pcall(function()
    if type(cmd) == "string" then
      vim.cmd(cmd)
    elseif type(cmd) == "function" then
      cmd()
    end
  end)
  if vim.api.nvim_get_current_win() == win_id then
    vim.fn.winrestview(view)
  end
end

return M
