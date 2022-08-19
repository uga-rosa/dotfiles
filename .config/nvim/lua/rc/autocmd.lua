local fn = vim.fn
local api = vim.api

local group_name = "vimrc"
api.nvim_create_augroup(group_name, { clear = true })

local zenhan = fn.resolve(fn.exepath("zenhan.exe"))
api.nvim_create_autocmd("InsertLeave", {
    group = group_name,
    pattern = "*",
    callback = function()
        if vim.bo.spelllang == "ja" then
            fn.system(zenhan .. " 0")
        end
    end,
})
