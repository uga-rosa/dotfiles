local map = utils.map
local augroup = utils.augroup

vim.g.neoterm_default_mod = "botright"
vim.g.neoterm_size = 15
vim.g.neoterm_autoinsert = true

map("t", "<esc>", "<C-\\><C-n>", "noremap")
map({ "n", "t" }, "<C-t>", "Ttoggle", { "noremap", "cmd" })

augroup({
  python = {
    "FileType",
    "python",
    function()
      map("n", "@r", "T python %", { "noremap", "buffer", "cmd" })
      map("n", "@t", "T pytest %", { "noremap", "buffer", "cmd" })
    end,
  },
  nim = {
    "FileType",
    "nim",
    function()
      map("n", "@r", "T nim c -r %", { "noremap", "buffer", "cmd" })
    end,
  },
})
