-- leader key is <Space>
vim.g.mapleader = " "

-- Disable mouse click
vim.keymap.set({ "", "!", "t" }, "<LeftMouse>", "<Nop>")
vim.keymap.set({ "", "!", "t" }, "<2-LeftMouse>", "<Nop>")

-- Release for prefix
vim.keymap.set("n", "s", "")
vim.keymap.set("n", "m", "")

-- go to home/end
vim.keymap.set({ "n", "x", "o" }, "H", function()
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
end, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "L", "$")

-- better o
vim.keymap.set("n", "o", "zzo")
vim.keymap.set("n", "O", "zzO")

-- insert blank line
vim.keymap.set("n", "<leader><CR>", "o<ESC>")
vim.keymap.set("n", "<leader><leader><CR>", "o<ESC>")

-- no highlight
vim.keymap.set("n", "<ESC><ESC>", "<Cmd>nohlsearch<CR>")

-- visual indent/dedent
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- erase x history
vim.keymap.set("n", "x", '"_x')

-- emacs key binding
-- for insert mode
vim.keymap.set("i", "<C-f>", "<C-g>U<Right>")
vim.keymap.set("i", "<C-b>", "<C-g>U<Left>")
vim.keymap.set("i", "<C-d>", "<Del>")

-- for command mode
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-h>", "<BS>")
vim.keymap.set("c", "<C-d>", "<Del>")

-- tab close
vim.keymap.set("n", "qt", "<Cmd>tabclose<CR>")

-- not include extra white space
-- vim.keymap.set({ "o", "x" }, "a'", "2i'")
-- vim.keymap.set({ "o", "x" }, 'a"', '2i"')
-- vim.keymap.set({ "o", "x" }, "a`", "2i`")

-- macro
vim.keymap.set("n", "Q", "@q")
