local utils = require("rc.utils")

local M = {}

M.sources = {
  default = { "vsnip", "nvim-lsp", "buffer" },
  skkeleton = { "skkeleton" },
  lua = { "vsnip", "nvim-lua", "nvim-lsp", "buffer" },
}

function M.patch_global(...)
  vim.fn["ddc#custom#patch_global"](...)
end

function M.patch_filetype(...)
  vim.fn["ddc#custom#patch_filetype"](...)
end

function M.patch_buffer(...)
  vim.fn["ddc#custom#patch_buffer"](...)
end

---@param type "source" | "filter"
---@param alias string
---@param base string
function M.alias(type, alias, base)
  vim.fn["ddc#custom#alias"](type, alias, base)
end

---@param fun function
---@return string
function M.register(fun)
  return vim.fn["denops#callback#register"](fun)
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
  local self = setmetatable({}, { __index = Menu })
  self:_buf_reset()
  return self
end

function Menu:_buf_reset()
  if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) then
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
  end
  self.bufnr = vim.api.nvim_create_buf(false, true)
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
  self:_buf_reset()
  self:_open(current_item)
end

function Menu:close()
  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end
  self.winid = nil
end

---@param height number
---@param width number
function Menu:_win_open(height, width)
  local pum_pos = vim.fn["pum#get_pos"]()
  local menu_row = pum_pos.row
  local menu_col = pum_pos.col + pum_pos.width + pum_pos.scrollbar
  self.winid = vim.api.nvim_open_win(self.bufnr, false, {
    relative = "editor",
    row = menu_row,
    col = menu_col,
    height = math.min(height, vim.opt.lines:get() - menu_row, self.max_height),
    width = math.min(width, vim.opt.columns:get() - menu_col, self.max_width),
    border = "single",
    zindex = 10000,
  })
  vim.api.nvim_set_option_value("wrap", false, { win = self.winid })
  vim.api.nvim_set_option_value("number", false, { win = self.winid })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = self.winid })
  vim.api.nvim_set_option_value("foldenable", false, { win = self.winid })
end

---@param expr string|nil|ddc.lsp.MarkupContent
---@return boolean
local function empty(expr)
  local expr_t = type(expr)
  if expr_t == "nil" then
    return true
  elseif expr_t == "string" then
    return expr == ""
  elseif expr_t == "table" then
    return expr.value == ""
  end
  return false
end

---@param input lsp.MarkedString | lsp.MarkedString[] | ddc.lsp.MarkupContent
---@param contents? string[]
---@return string[] contents
local function converter(input, contents)
  return vim.lsp.util.convert_input_to_markdown_lines(input, contents)
end

---@param item DdcItem
function Menu:_open(item)
  if item.__sourceName == "vsnip" then
    local documents = converter({
      language = vim.bo.filetype,
      value = vim.fn["vsnip#to_string"](item.user_data.vsnip.snippet),
    })
    self:_post_markdown(documents)
  elseif item.__sourceName == "nvim-lsp" then
    ---@type ddc.lsp.CompletionItem
    local lspItem = vim.json.decode(item.user_data.lspitem)
    if lspItem.documentation == nil then
      local clientId = item.user_data.clientId
      lspItem = require("ddc_nvim_lsp.internal").resolve(clientId, lspItem) or lspItem
    end
    ---@type string[]
    local documents = {}

    -- detail
    if not empty(lspItem.detail) then
      documents = converter({
        language = vim.bo.filetype,
        value = lspItem.detail,
      }, documents)
    end

    -- documentation
    if not empty(lspItem.documentation) then
      if #documents > 0 then
        documents = converter("---", documents)
      end
      documents = converter(lspItem.documentation, documents)
    end

    self:_post_markdown(documents)
  elseif item.__sourceName == "nvim-lua" then
    local help_tag = item.user_data.help_tag --[[@as string]]
    if help_tag == "" then
      return
    end

    self:_win_open(self.max_height, 78)
    vim.api.nvim_set_option_value("buftype", "help", { buf = self.bufnr })
    vim.api.nvim_win_call(self.winid, function()
      local ok = pcall(vim.cmd.help, help_tag)
      if not ok then
        self:close()
      end
    end)
  end
end

---@param documents string[]
function Menu:_post_markdown(documents)
  if #documents == 0 then
    return
  end
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, documents)
  vim.lsp.util.stylize_markdown(self.bufnr, documents, {
    max_height = self.max_height,
    max_width = self.max_width,
  })
  local lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, true)
  self:_win_open(#lines, utils.max(lines, vim.api.nvim_strwidth))
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
