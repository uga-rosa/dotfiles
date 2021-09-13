local map = utils.map
local augroup = utils.augroup

vim.g.neoterm_default_mod = "botright"
vim.g.neoterm_size = 15
vim.g.neoterm_autoinsert = true

map("t", "<esc>", "<C-\\><C-n>", "noremap")
map("t", "<C-w>", "<C-\\><C-n><C-w>", "noremap")
map("t", "<C-h>", "<bs>", "noremap")
map({ "n", "t" }, "<C-t>", "Ttoggle", { "noremap", "cmd" })

augroup({
  neoterm = {
    { "FileType", "neoterm", "setl nobuflisted" },
    {
      "FileType",
      "python",
      function()
        map("n", "@r", "T python %", { "noremap", "buffer", "cmd" })
        map("n", "@t", "T pytest %", { "noremap", "buffer", "cmd" })
      end,
    },
    {
      "FileType",
      "nim",
      function()
        map("n", "@r", { "w", "T nim c -r %", "Topen" }, { "noremap", "buffer", "cmd" })
        map("n", "@c", { "w", "T nim c %", "Topen" }, { "noremap", "buffer", "cmd" })
      end,
    },
  },
})
