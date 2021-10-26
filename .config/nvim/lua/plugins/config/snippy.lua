local map = require("snippy.mapping")
map.setup({
  ["<C-j>"] = {
    func = map.jump_next(),
    mode = { "i", "s" },
  },
  ["<C-k>"] = {
    func = map.jump_prev(),
    mode = { "i", "s" },
  },
  ["<leader>c"] = {
    str = "<Plug>(snippy-cut-text)",
    mode = { "n", "x" },
  },
})

myutils.map("s", "<C-h>", "x<bs>", "noremap")
