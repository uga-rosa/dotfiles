local map = utils.map
local augroup = utils.augroup

augroup("molder-mapping", {
  {
    "FileType",
    "molder",
    function()
      map("n", "h", "<Plug>(molder-up)", { "buffer", "nowait" })
      map("n", "l", "<Plug>(molder-open)", { "buffer", "nowait" })
      map("n", "<cr>", "<Plug>(molder-open)", { "buffer", "nowait" })
      map("n", "<C-r>", "<Plug>(molder-reload)", { "buffer", "nowait" })
      map("n", "h", "<Plug>(molder-up)", { "buffer", "nowait" })
      map("n", "+", "<Plug>(molder-toggle-hidden)", { "buffer", "nowait" })
      -- operation
      map("n", "nd", "<Plug>(molder-operations-newdir)", { "buffer", "nowait" })
      map("n", "nf", "<Plug>(molder-operations-newfile)", { "buffer", "nowait" })
      map("n", "d", "<Plug>(molder-operations-delete)", { "buffer", "nowait" })
      map("n", "r", "<Plug>(molder-operations-rename)", { "buffer", "nowait" })
      map("n", "!", "<Plug>(molder-operations-command)", { "buffer", "nowait" })
    end,
  },
})
