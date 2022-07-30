local map = utils.keymap.set

-- leader key is <Space>
vim.g.mapleader = " "

-- Release for prefix
map("n", "s", "")
map("n", "m", "")

-- go to home/end
map("nxo", "H", "^")
map("nxo", "L", "$")

-- better o
map("n", "o", "zzo")
map("n", "O", "zzO")

-- insert blank line
map("n", "<leader><CR>", "o<ESC>")
map("n", "<leader><leader><CR>", "o<ESC>")

-- no highlight
map("n", "<ESC><ESC>", "<Cmd>nohlsearch<CR>")

-- visual indent/dedent
map("x", "<", "<gv")
map("x", ">", ">gv")

-- erase x history
map("n", "x", '"_x')

-- emacs key binding
-- for insert mode
map("i", "<C-f>", "<C-g>U<Right>")
map("i", "<C-b>", "<C-g>U<Left>")
map("i", "<C-d>", "<Del>")

-- for command mode
map("c", "<C-f>", "<Right>")
map("c", "<C-b>", "<Left>")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<C-h>", "<BS>")
map("c", "<C-d>", "<Del>")

-- tab close
map("n", "qt", "<Cmd>tabclose<CR>")
