local fn = vim.fn
local api = vim.api

local group_name = "vimrc"
api.nvim_create_augroup(group_name, { clear = true })

-- The path resolution is slow (takes about 10ms), so delay it to speed up the startup.
local zenhan
api.nvim_create_autocmd("InsertLeave", {
  group = group_name,
  pattern = "*",
  callback = function()
    if not zenhan then
      zenhan = fn.resolve(fn.exepath("zenhan.exe"))
    end
    if vim.bo.spelllang == "ja" then
      fn.system(zenhan .. " 0")
    end
  end,
})
