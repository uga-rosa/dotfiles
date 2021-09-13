local M = {}

local map = utils.map
local command = utils.command

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

M.filittle = function()
  require("filittle").setup({
    devicons = true,
  })

  require("nvim-web-devicons").setup({
    override = {
      nim = {
        icon = "",
        color = "#ffff00",
        name = "Nim",
      },
    },
  })
end

return M
