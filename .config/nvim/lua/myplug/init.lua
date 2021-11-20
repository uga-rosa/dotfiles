local M = {}

local augroup = vim_api.augroup

M.setup = function()
    augroup({
        markdown = {
            {
                "FileType",
                "markdown",
                "++once",
                function()
                    vim.g.markdown_fenced_languages = { "lua", "python", "rust" }
                    require("myplug.pasteimage").setup()
                    require("myplug.table").setup()
                end,
            },
        },
    })
end

return M
