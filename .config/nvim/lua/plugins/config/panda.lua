local map = myutils.map
local augroup = myutils.augroup

local panda = require("panda")
panda.setup()

local slide_opt = {
    css = false,
    _opt = {
        "-s",
        "-t",
        "revealjs",
        "-V",
        "theme=moon",
    },
}

map("n", "<leader>pn", function()
    vim.b.panda_started = true
    local firstline = vim.fn.getline(1)
    if firstline:match("^%%") then
        panda.run(slide_opt)
    else
        panda.run()
    end
end)

augroup({
    panda = {
        {
            "BufWritePost",
            "*.md",
            function()
                if not vim.b.panda_started then
                    return
                end
                local firstline = vim.fn.getline(1)
                if firstline:match("^%%") then
                    panda.convert(slide_opt)
                else
                    panda.convert()
                end
            end,
        },
    },
})
