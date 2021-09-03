local res, gitsigns = pcall(require, "gitsigns")
if not res then
  return
end

gitsigns.setup({
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

    ["n <leader>gs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["v <leader>gs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>gu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>gR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    ["n <leader>gS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    ["n <leader>gU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    -- Text objects
    ["o ig"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ["x ig"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
  },
})
