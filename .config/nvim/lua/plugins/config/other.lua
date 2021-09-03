local M = {}

local map = utils.map
local aug = utils.augroup

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
  map("n", "s", "<Plug>(operator-replace)")
end

M.openbrowser = function()
  map({ "n", "x" }, "<M-o>", "<Plug>(openbrowser-smart-search)")
  vim.g.openbrowser_browser_commands = {
    { name = "chrome.exe", args = { "{browser}", "{uri}" } },
  }
end

M.filittle = function()
  local res, filittle = pcall(require, "filittle")
  if not res then
    return
  end
  filittle.setup({
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
end

M.panda = function()
  require("panda").setup({
    browser = "chrome.exe",
    opt = {
      "--mathjax",
    },
  })
  map("n", "<leader>m", '<cmd>lua require("panda").run()<cr>')
  aug("mypanda", {
    { "BufWritePost", "*.md", 'lua require("panda").convert()' },
  })
  vim.cmd('command! PandaConvert lua require("panda").run({dir = "html"})')
end

return M
