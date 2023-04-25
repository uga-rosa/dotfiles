local heirline = require("heirline")

---@param winid integer?
---@return boolean
local function is_float_win(winid)
  local config = vim.api.nvim_win_get_config(winid or 0)
  return config.relative ~= ""
end

local function is_disable_buf(bufid)
  local filetype = vim.api.nvim_buf_get_option(bufid, "filetype")
  return ({
    fern = true,
    ugaterm = true,
  })[filetype]
end

heirline.setup({
  opts = {
    colors = require("rc.heirline.colors"),
    disable_winbar_cb = function(arg)
      return is_float_win() or is_disable_buf(arg.buf)
    end,
  },
  statusline = {
    -- global setting
    hl = { fg = "fg", bg = "bg" },

    -- left
    require("rc.heirline.mode"),
    require("rc.heirline.git"),
    require("rc.heirline.diagnostics"),
    require("rc.heirline.file"),
    { provider = "%=" },

    -- middle
    { provider = "%=" },

    -- right
    require("rc.heirline.lsp"),
    {
      provider = " ",
    },
    {
      provider = "%7(%l/%3L%):%2c %P",
      hl = { fg = "bg", bg = "fg" },
    },
  },
  winbar = {
    require("rc.heirline.navic"),
  },
})
