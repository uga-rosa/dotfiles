vim.g.searchx = {
    auto_accept = true,
    scrolloff = vim.opt.scrolloff:get(),
    scrolltime = 0,
    nohlsearch = {
        jump = true,
    },
    markers = vim.split("ASDFGHJKL:QWERTYUIOP", ""),
}

vim.keymap.set({ "n", "x" }, "/", "<Cmd>call searchx#start({'dir': 1})<CR>")
vim.keymap.set({ "n", "x" }, "?", "<Cmd>call searchx#start({'dir': 0})<CR>")
vim.keymap.set({ "n", "x" }, "n", "<Cmd>call searchx#next()<CR>")
vim.keymap.set({ "c" }, "<C-j>", "<Cmd>call searchx#next()<CR>")
vim.keymap.set({ "n", "x" }, "N", "<Cmd>call searchx#prev()<CR>")
vim.keymap.set({ "c" }, "<C-k>", "<Cmd>call searchx#prev()<CR>")
vim.keymap.set({ "n", "c" }, "<C-l>", "<Cmd>call searchx#clear()<CR>")
