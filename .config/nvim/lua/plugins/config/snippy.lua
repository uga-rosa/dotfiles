local snippy = require("snippy")
snippy.setup({
    choice_delay = 0,
})

local map = vim_api.map
local cmp = require("cmp")

map({ "i", "s" }, "<C-j>", function(fallback)
    if snippy.can_jump(1) then
        if cmp.visible() then
            cmp.close()
        end
        snippy.next()
    else
        fallback()
    end
end)

map({ "i", "s" }, "<C-k>", function(fallback)
    if snippy.can_jump(-1) then
        if cmp.visible() then
            cmp.close()
        end
        snippy.previous()
    else
        fallback()
    end
end)

map("s", "<C-h>", "x<bs>", "noremap")

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
