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
  if current_item == nil then
    return
  end
  local documents = self.get_documentation(current_item)
  if #documents == 0 then
    return
  end

  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, documents)
  vim.lsp.util.stylize_markdown(self.bufnr, documents, {
    max_height = 30,
    max_width = 80,
  })

  local lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, true)
  local pum_pos = vim.fn["pum#get_pos"]()
  local col = pum_pos.col + pum_pos.width
  local width = utils.max(lines, vim.api.nvim_strwidth)
  self.winid = vim.api.nvim_open_win(self.bufnr, false, {
    relative = "editor",
    height = math.min(#lines, vim.opt.lines:get() - pum_pos.row, 30),
    width = math.min(width, vim.opt.columns:get() - col, 80),
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

---@param item table
---@return string[]
function Menu.get_documentation(item)
  if item.__sourceName == "vsnip" then
    local data = vim.json.decode(item.user_data)
    return vim.lsp.util.convert_input_to_markdown_lines({
      language = vim.bo.filetype,
      value = vim.fn["vsnip#to_string"](data.vsnip.snippet),
    })
  elseif item.__sourceName == "nvim-lsp" then
    local completionItem = vim.json.decode(item.user_data.lspitem)
    local documents = {}

    -- detail
    if completionItem.detail and completionItem.detail ~= "" then
      local ft = vim.bo.filetype
      local dot_index = string.find(ft, "%.")
      if dot_index ~= nil then
        ft = string.sub(ft, 0, dot_index - 1)
      end
      table.insert(documents, {
        kind = "markdown",
        value = ("```%s\n%s\n```"):format(ft, vim.trim(completionItem.detail)),
      })
    end

    local documentation = completionItem.documentation
    if type(documentation) == "string" and documentation ~= "" then
      local value = vim.trim(documentation)
      if value ~= "" then
        table.insert(documents, {
          kind = "plaintext",
          value = value,
        })
      end
    elseif type(documentation) == "table" and documentation.value then
      local value = vim.trim(documentation.value)
      if value ~= "" then
        table.insert(documents, {
          kind = documentation.kind,
          value = value,
        })
      end
    end

    return vim.lsp.util.convert_input_to_markdown_lines(documents)
  else
    return {}
  end
end

local menu = Menu.new()

M.menu = {
  open = function()
    utils.debounse("menu_open", function()
      menu:open()
    end, 100)
  end,
  close = function()
    utils.debounse("menu_open", function()
      menu:open()
    end, 100)
  end,
}

return M
