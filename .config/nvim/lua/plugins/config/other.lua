local M = {}

local map = myutils.map

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

M.eft = function()
  map({ "n", "x" }, ";", "<Plug>(eft-repeat)")
  map({ "n", "x", "o" }, "f", "<Plug>(eft-f)")
  map({ "n", "x", "o" }, "F", "<Plug>(eft-F)")
  map({ "n", "x", "o" }, "t", "<Plug>(eft-t)")
  map({ "n", "x", "o" }, "T", "<Plug>(eft-T)")
  vim.cmd("let g:eft_index_function = {'all': { -> v:true}}")
end

return M
