local snippy = require("snippy")
snippy.setup({
    choice_delay = 0,
    mappings = {
        is = {
            ["<C-j>"] = "next",
            ["<C-k>"] = "previous",
        },
    },
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
