local heirline = require("heirline")

heirline.setup({
  opts = {
    colors = require("rc.heirline.colors"),
    disable_winbar_cb = function(args)
      local buf = args.buf
      local ft = vim.bo[buf].filetype
      local excludes = { "fzf" }
      return vim.tbl_contains(excludes, ft)
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
