vim.g.searchx = {
    auto_accept = true,
    scrolloff = vim.opt.scrolloff:get(),
    scrolltime = 0,
    nohlsearch = {
        jump = true,
    },
    markers = vim.split("ASDFGHJKL:QWERTYUIOP", "")
}

local map = utils.keymap.set

map("nx", "/", "<Cmd>call searchx#start({'dir': 1})<CR>")
map("nx", "?", "<Cmd>call searchx#start({'dir': 0})<CR>")
map("nx", "n", "<Cmd>call searchx#next()<CR>")
map("c", "<C-j>", "<Cmd>call searchx#next()<CR>")
map("nx", "N", "<Cmd>call searchx#prev()<CR>")
map("c", "<C-k>", "<Cmd>call searchx#prev()<CR>")
map("nc", "<C-l>", "<Cmd>call searchx#clear()<CR>")
