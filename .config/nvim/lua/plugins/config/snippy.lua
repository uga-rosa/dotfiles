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
    choice_delay = 0,
})

myutils.map("s", "<C-h>", "x<bs>", "noremap")
