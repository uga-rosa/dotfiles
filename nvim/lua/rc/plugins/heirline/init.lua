---@type PluginSpec
local spec = {
  "rebelot/heirline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "vim-nightfly-colors",
  },
  config = function()
    require("heirline").setup({
      opts = {
        colors = require("rc.plugins.heirline.colors"),
      },
      statusline = {
        -- global setting
        hl = { fg = "fg", bg = "bg" },

        -- left
        require("rc.plugins.heirline.mode"),
        require("rc.plugins.heirline.git"),
        require("rc.plugins.heirline.diagnostics"),
        require("rc.plugins.heirline.file"),
        { provider = "%=" },

        -- middle
        { provider = "%=" },

        -- right
        require("rc.plugins.heirline.lsp"),
        {
          provider = " ",
        },
        {
          provider = "%7(%l/%3L%):%2c %P",
          hl = { fg = "bg", bg = "fg" },
        },
      },
    })
  end,
}

return spec
