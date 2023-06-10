---@type LazySpec
local spec = {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          mappings = {
            n = {
              ["<Esc>"] = { "Close", nowait = true },
              ["q"] = { "Close", nowait = true },
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },
        },
        select = {
          enabled = true,
          backend = { "builtin" },
        },
      })
    end,
  },
  {
    "MunifTanjim/nui.nvim",
  },
}

return spec
