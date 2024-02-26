---@type LazySpec
local spec = {
  {
    "bluz71/vim-nightfly-colors",
    config = function()
      vim.g.nightflyItalics = false
      vim.cmd.colorscheme("nightfly")

      local palette = require("nightfly").palette

      vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.black })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.white, bg = palette.black })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = palette.cyan_blue })
      vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    dev = true,
    event = "BufRead",
    config = function()
      local ccc = require("ccc")

      ccc.setup({
        default_color = "#40bfbf",
        highlighter = {
          auto_enable = true,
          excludes = {
            "ddu-ui",
            "ddu-ui-filter",
          },
        },
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_hwb,
          ccc.picker.css_lab,
          ccc.picker.css_lch,
          ccc.picker.css_oklab,
          ccc.picker.css_oklch,
          ccc.picker.trailing_whitespace({
            enable = { "markdown", "help" },
          }),
        },
      })
    end,
  },
}

return spec
