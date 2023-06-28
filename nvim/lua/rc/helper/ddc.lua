local utils = require("rc.utils")

local M = {}

function M.patch_global(...)
  vim.fn["ddc#custom#patch_global"](...)
end

function M.patch_filetype(...)
  vim.fn["ddc#custom#patch_filetype"](...)
end

---@class Menu
---@field public max_height number
---@field public max_width number
---@field bufnr number
---@field winid? number
local Menu = {
  max_height = 30,
  max_width = 80,
}

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
  if current_item == nil then
    return
  end
  local documents = self.get_documentation(current_item)
  if #documents == 0 then
    return
  end

  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, documents)
  vim.lsp.util.stylize_markdown(self.bufnr, documents, {
    max_height = self.max_height,
    max_width = self.max_width,
  })

  local lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, true)
  local pum_pos = vim.fn["pum#get_pos"]()
  local menu_row = pum_pos.row
  local menu_col = pum_pos.col + pum_pos.width
  self.winid = vim.api.nvim_open_win(self.bufnr, false, {
    relative = "editor",
    row = menu_row,
    col = menu_col,
    height = math.min(#lines, vim.opt.lines:get() - menu_row, self.max_height),
    width = math.min(
      utils.max(lines, vim.api.nvim_strwidth),
      vim.opt.columns:get() - menu_col,
      self.max_width
    ),
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

local function empty(expr)
  return expr == nil or expr == ""
end

---@alias lsp.MarkedString string | { language: string, value: string }

---@param item table
---@return string[]
function Menu.get_documentation(item)
  if item.__sourceName == "vsnip" then
    return vim.lsp.util.convert_input_to_markdown_lines({
      language = vim.bo.filetype,
      value = vim.fn["vsnip#to_string"](item.user_data.vsnip.snippet),
    })
  elseif item.__sourceName == "nvim-lsp" then
    ---@type lsp.CompletionItem
    local lspItem = vim.json.decode(item.user_data.lspitem)
    ---@type (lsp.MarkedString | lsp.MarkedString[] | lsp.MarkupContent)[]
    local documents = {}

    -- detail
    if not empty(lspItem.detail) then
      table.insert(documents, {
        language = vim.bo.filetype,
        value = lspItem.detail,
      })
    end

    -- documentation
    if not empty(lspItem.documentation) then
      if #documents > 0 then
        table.insert(documents, "---")
      end
      table.insert(documents, lspItem.documentation)
    end

    return vim.lsp.util.convert_input_to_markdown_lines(documents)
  else
    return {}
  end
end

M.menu = {
  enable = function()
    local menu = Menu.new()
    local group = vim.api.nvim_create_augroup("pum-menu", {})
    vim.api.nvim_create_autocmd("User", {
      pattern = "PumCompleteChanged",
      group = group,
      callback = function()
        utils.debounse("menu_open", function()
          menu:open()
        end, 100)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = { "PumClose", "PumCompleteDone" },
      group = group,
      callback = function()
        menu:close()
      end,
    })
  end,
  disable = function()
    vim.api.nvim_del_augroup_by_name("pum-menu")
  end,
}

return M
