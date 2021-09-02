local lsp, api, fn = vim.lsp, vim.api, vim.fn
local map = utils.map

local close_rename_win = function(win)
  if fn.mode() == "i" then
    vim.cmd([[stopinsert]])
  end
  api.nvim_win_close(win, true)
end

local dorename = function(win)
  local new_name = vim.trim(fn.getline("."):sub(3, -1))
  close_rename_win(win)
  if not (new_name and #new_name > 0) then
    return
  end
  lsp.buf.rename(new_name)
end

local rename = function()
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
  local cmd1 = "<cmd>lua Rename.dorename(" .. win .. ")<cr>"
  local cmd2 = "<cmd>lua Rename.close(" .. win .. ")<cr>"
  map("i", "<cr>", cmd1, { "noremap", "buffer", "nowait" })
  map("i", "<C-c>", cmd2, { "noremap", "buffer", "nowait" })
  map("n", "<esc>", cmd2, { "noremap", "buffer", "nowait" })
  map("n", "q", cmd2, { "noremap", "buffer", "nowait" })
end

_G.Rename = {
  close = close_rename_win,
  rename = rename,
  dorename = dorename,
}

map("n", "<leader>rn", "<cmd>lua Rename.rename()<cr>", "noremap")
