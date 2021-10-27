local snippy = require("snippy")
snippy.setup({
    mappings = {
        [{ "i", "s" }] = {
            ["<C-j>"] = "next",
            ["<C-k>"] = "previous",
        },
        [{ "n", "x" }] = {
            ["<leader>c"] = "cut_text",
        },
    },
})

myutils.map("s", "<C-h>", "x<bs>", "noremap")

vim.g.snippy_choice_delay = 100
