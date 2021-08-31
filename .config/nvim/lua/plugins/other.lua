local M = {}

local map = utils.map

M.lualine = function()
  local res, lualine = pcall(require, "lualine")

  if res and vim.fn.exists("vim_starting") == 1 then
    lualine.setup({
      options = { theme = "nightfly" },
    })
  end
end

M.easyalign = function()
  map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
end

M.operator_replace = function()
  map("n", "_", "<Plug>(operator-replace)")
end

M.openbrowser = function()
  map({ "n", "x" }, "<M-o>", "<Plug>(openbrowser-smart-search)")
  vim.g.openbrowser_browser_commands = {
    { name = "chrome.exe", args = { "{browser}", "{uri}" } },
  }
end

return M
