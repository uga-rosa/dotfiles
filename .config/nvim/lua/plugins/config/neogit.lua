local M = {}

M.setup = function()
    myutils.map("n", "<leader>n", "Neogit kind=tab", "cmd")
end

M.config = function()
    require("neogit").setup({
        integrations = {
            diffview = true,
        },
    })
end

return M
