local utils = require("rc.utils")

local M = {}

function M.patch_global(...)
  vim.fn["ddc#custom#patch_global"](...)
end

function M.patch_filetype(...)
  vim.fn["ddc#custom#patch_filetype"](...)
end

---@class Menu
---@field bufnr number
---@field winid? number
local Menu = {}

---@return Menu
function Menu.new()
  return setmetatable({
    bufnr = vim.api.nvim_create_buf(false, true),
  }, { __index = Menu })
end

function Menu:open()
  self:close()

  if not vim.fn["pum#visible"]() then
    return
  end
  local complete_info = vim.fn["pum#complete_info"]()
  local current_item = complete_info.items[complete_info.selected + 1]
  local menu = self.get_menu(current_item)
  if menu == nil then
    return
  end

  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, menu)
  vim.api.nvim_set_option_value("filetype", vim.bo.filetype, { buf = self.bufnr })

  local pum_pos = vim.fn["pum#get_pos"]()
  local col = pum_pos.col + pum_pos.width
  local width = utils.max(menu, vim.api.nvim_strwidth)
  self.winid = vim.api.nvim_open_win(self.bufnr, false, {
    relative = "editor",
    width = math.min(width, vim.opt.columns:get() - col),
    height = #menu,
    row = pum_pos.row,
    col = col,
    border = "single",
    zindex = 10000,
  })

  vim.api.nvim_set_option_value("wrap", false, { win = self.winid })
  vim.api.nvim_set_option_value("number", false, { win = self.winid })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = self.winid })
  vim.api.nvim_set_option_value("foldenable", false, { win = self.winid })
end

function Menu:close()
  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end
  self.winid = nil
end

---@param item? table
---@return string[]?
function Menu.get_menu(item)
  if item == nil then
    return
  elseif item.__sourceName == "vsnip" then
    local data = vim.json.decode(item.user_data)
    return vim.split(vim.fn["vsnip#to_string"](data.vsnip.snippet), "\n")
  end
end

M.menu = Menu.new()

return M
