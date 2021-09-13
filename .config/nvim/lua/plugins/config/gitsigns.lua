require("gitsigns").setup({
  keymaps = {
    noremap = true,

    ["n ]g"] = {
      expr = true,
      "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
    },
    ["n [g"] = {
      expr = true,
      "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
    },

    ["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

    -- Text objects
    ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
  },
})
