local map = Keymap.set
local Api = require("nvim-tree.api")

map("n", "<M-f>", "<Cmd>NvimTreeToggle<CR>")

require("nvim-tree").setup({
    on_attach = function(bufnr)
        map("n", "l", Api.node.open.edit, "", bufnr)
        map("n", "h", Api.node.navigate.parent_close, "", bufnr)
    end,
})
