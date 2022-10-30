local Api = require("nvim-tree.api")

vim.keymap.set("n", "<M-f>", "<Cmd>NvimTreeToggle<CR>")

require("nvim-tree").setup({
    on_attach = function(bufnr)
        vim.keymap.set("n", "l", Api.node.open.edit, "", { buffer = bufnr })
        vim.keymap.set("n", "h", Api.node.navigate.parent_close, "", { buffer = bufnr })
    end,
})
