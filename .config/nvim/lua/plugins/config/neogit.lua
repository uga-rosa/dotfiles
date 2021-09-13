local M = {}

M.setup = function()
  myutils.map("n", "<leader>n", "Neogit kind=split", "cmd")
end

M.config = function()
  require("neogit").setup({})
end

return M
