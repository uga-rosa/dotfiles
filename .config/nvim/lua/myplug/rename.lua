local M = {}

local lsp = vim.lsp
local api = vim.api
local fn = vim.fn
local map = utils.map

M.close = function(win)
  if fn.mode() == "i" then
    vim.cmd([[stopinsert]])
  end
  api.nvim_win_close(win, true)
end

M.rename = function(win)
  local new_name = vim.trim(fn.getline("."):sub(3, -1))
  M.close(win)
  if not (new_name and #new_name > 0) then
    return
  end
  lsp.buf.rename(new_name)
end

M.open = function()
  local opts = {
    relative = "cursor",
    row = 1,
    col = -2,
    width = 30,
    height = 1,
    style = "minimal",
    border = "single",
  }
  local cword = fn.expand("<cword>")
  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(buf, true, opts)

  vim.bo.buftype = "prompt"
  vim.bo.bufhidden = "wipe"
  fn.prompt_setprompt(buf, "> ")
  api.nvim_buf_set_lines(buf, -1, -1, false, { cword })
  vim.cmd([[startinsert!]])

  local rename = function()
    M.rename(win)
  end
  local close = function()
    M.close(win)
  end

  local map_opt = { "buffer", "nowait" }

  map("i", "<cr>", rename, map_opt)
  map("i", "<C-c>", close, map_opt)
  map("n", "<esc>", close, map_opt)
  map("n", "q", close, map_opt)
end

M.setup = function()
  map("n", "<leader>r", M.open)
end

return M
