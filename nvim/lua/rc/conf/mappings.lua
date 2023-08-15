-- Disable mouse click for all mode
for _, pos in ipairs({ "Left", "Right", "Middle" }) do
  vim.keymap.set({ "", "i", "c", "t" }, ("<%sMouse>"):format(pos), "<Nop>")
  for _, pre in ipairs({ "2", "3", "4", "S", "C", "A" }) do
    vim.keymap.set({ "", "i", "c", "t" }, ("<%s-%sMouse>"):format(pre, pos), "<Nop>")
  end
end

-- swap ; and :
vim.keymap.set("", ";", ":")
vim.keymap.set("", ":", ";")

-- 7sPro
for _, mode in ipairs({ "n", "x", "o", "i", "c", "t" }) do
  vim.keymap.set(mode, "<Right>", "<C-f>", { remap = true })
  vim.keymap.set(mode, "<Left>", "<C-b>", { remap = true })
  vim.keymap.set(mode, "<Up>", "<C-p>", { remap = true })
  vim.keymap.set(mode, "<Down>", "<C-n>", { remap = true })
  vim.keymap.set(mode, "<Del>", "<C-d>", { remap = true })
  vim.keymap.set(mode, "<BS>", "<C-h>", { remap = true })
  vim.keymap.set(mode, "<Home>", "<C-a>", { remap = true })
  vim.keymap.set(mode, "<End>", "<C-e>", { remap = true })
end

-- Release for prefix
vim.keymap.set("n", "s", "<Nop>")

-- Enable <Esc> in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Go to first/end line
vim.keymap.set({ "n", "x", "o" }, "H", "^")
vim.keymap.set({ "n", "x", "o" }, "L", "$")

-- Easy to see o/O
vim.keymap.set("n", "o", "zzo")
vim.keymap.set("n", "O", "zzO")

-- Insert blank line
vim.keymap.set("n", "<Space><CR>", "o<Esc>")
vim.keymap.set("n", "<Space><Space><CR>", "O<Esc>")

-- No highlight
vim.keymap.set("n", "<Esc><Esc>", "<Cmd>nohl<CR>")

-- Erase x history
vim.keymap.set("n", "x", '"_x')

-- Emacs keybinding (Insert mode)
vim.keymap.set("i", "<C-f>", "<C-g>U<Right>")
vim.keymap.set("i", "<C-b>", "<C-g>U<Left>")
vim.keymap.set("i", "<C-d>", "<Del>")
-- Use emcl.nvim for command mode

-- Macro
vim.keymap.set("n", "Q", "@q")

-- Buffer move
vim.keymap.set("n", "[b", "<Cmd>bprevious<CR>", { silent = true })
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>", { silent = true })
vim.keymap.set("n", "[B", "<Cmd>bfirst<CR>", { silent = true })
vim.keymap.set("n", "]B", "<Cmd>blast<CR>", { silent = true })

-- Tabpage move
vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>", { silent = true })
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "[T", "<Cmd>tabfirst<CR>", { silent = true })
vim.keymap.set("n", "]T", "<Cmd>tablast<CR>", { silent = true })

-- Substitute all
vim.keymap.set("ca", "s", function()
  if vim.fn.getcmdtype() .. vim.fn.getcmdline() == ":s" then
    vim.fn.getchar()
    return "%s///g<Left><Left>"
  else
    return "s"
  end
end, { expr = true })
