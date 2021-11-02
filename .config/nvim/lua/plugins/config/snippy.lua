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

vim_api.map("s", "<C-h>", "x<bs>", "noremap")

local snippet_dir = vim.fn.stdpath("config") .. "/snippets/"
vim_api.command({
    "SnipEdit",
    function()
        local ft = vim.bo.filetype
        if ft == "" then
            print("No file type is set.")
        else
            vim.cmd("split " .. snippet_dir .. vim.bo.filetype .. ".snippets")
        end
    end,
})
