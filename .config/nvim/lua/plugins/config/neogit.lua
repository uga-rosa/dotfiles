local M = {}

M.setup = function()
    vim_api.map("n", "<leader>n", "Neogit kind=tab", "cmd")
end

M.config = function()
    require("neogit").setup({
        integrations = {
            diffview = true,
        },
    })
end

return M
