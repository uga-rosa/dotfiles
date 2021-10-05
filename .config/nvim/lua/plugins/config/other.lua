local M = {}

local map = myutils.map
local command = myutils.command

M.colorizer = function()
  command({
    "ColorizerSetup",
    function()
      require("colorizer").setup()
      vim.cmd("e")
    end,
  })
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

M.sandwich = function()
  vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
end

M.filittle = function()
  require("nvim-web-devicons").set_icon({
    nim = {
      icon = "",
      color = "#ffff00",
      name = "Nim",
    },
  })
end

return M
