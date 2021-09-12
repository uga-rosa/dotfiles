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
    mappings = {
      ["<cr>"] = "open",
      ["l"] = "open",
      ["<C-x>"] = "split",
      ["<C-v>"] = "vsplit",
      ["<C-t>"] = "tabedit",
      ["h"] = "up",
      ["~"] = "home",
      ["R"] = "reload",
      ["+"] = "toggle_hidden",
      ["t"] = "touch",
      ["m"] = "mkdir",
      ["d"] = "delete",
      ["r"] = "rename",
    },
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
