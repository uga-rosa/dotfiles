local snippy = require("snippy")
snippy.setup({
    mappings = {
        is = {
            ["<C-j>"] = "next",
            ["<C-k>"] = "previous",
        },
        nx = {
            ["<leader>c"] = "cut_text",
        },
    },
})

myutils.map("s", "<C-h>", "x<bs>", "noremap")

vim.g.snippy_choice_delay = 100
