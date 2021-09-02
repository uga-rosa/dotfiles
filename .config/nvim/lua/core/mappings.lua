local fn = vim.fn
local map = utils.map
local map_conv = utils.map_conv

vim.g.mapleader = " "

map("n", "Q", "q", "noremap")
map("n", "<leader><esc>", "<cmd>noh<cr>", "noremap")
map("v", "<", "<gv", "noremap")
map("v", ">", ">gv", "noremap")
map("n", "+", "<C-a>", "noremap")
map("n", "-", "<C-x>", "noremap")
map("n", "<leader><cr>", "o<esc>", "noremap")
map("n", "Y", "y$", "noremap")
map("n", "x", '"_x', "noremap")
map("n", "s", '"_s', "noremap")
map("", "H", "^", "noremap")
map("", "L", "$", "noremap")
map_conv("n", "j", "gj", "noremap")
map_conv("n", "k", "gk", "noremap")
local motions = { ["<C-j>"] = "、", ["<C-k>"] = "。" }
local operators = { "f", "F", "t", "T" }
for _, o in ipairs(operators) do
  for before, after in pairs(motions) do
    map("n", o .. before, o .. after, "noremap")
  end
end
map({ "i", "c" }, "<C-f>", "<right>", "noremap")
map({ "i", "c" }, "<C-b>", "<left>", "noremap")
map({ "i", "c" }, "<C-d>", "<delete>", "noremap")
map("c", "<C-a>", "<home>", "noremap")
map("c", "<C-e>", "<end>", "noremap")
map("c", "<C-x>", [[expand('%:p')]], { "noremap", "expr" })
map("n", "0", function()
  if fn.getline("."):sub(1, fn.col(".") - 1):match("^%s+$") then
    vim.api.nvim_feedkeys("0", "n", true)
  else
    vim.api.nvim_feedkeys("^", "n", true)
  end
end)
