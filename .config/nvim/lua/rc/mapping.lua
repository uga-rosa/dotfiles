local map = Keymap.set

-- leader key is <Space>
vim.g.mapleader = " "

-- Release for prefix
map("n", "s", "")
map("n", "m", "")

-- go to home/end
map("nxo", "H", function()
    local col = vim.fn.col(".")
    if col == 1 then
        return "^"
    end
    local line_before_cursor = vim.api.nvim_get_current_line():sub(1, col - 1)
    if line_before_cursor:find("^%s+$") then
        return "0"
    else
        return "^"
    end
end, "e")
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

-- keychron q4
map("", "<HOME>", "<C-a>", "r")
map("", "<END>", "<C-e>", "r")
map("", "<Right>", "<C-f>", "r")
map("", "<Left>", "<C-b>", "r")
map("", "<Up>", "<C-p>", "r")
map("", "<Down>", "<C-n>", "r")
map("", "<BS>", "<C-h>", "r")
map("", "<Del>", "<C-d>", "r")

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

-- macro
map("n", "Q", "@q")
