local group_name = "vimrc"
vim.api.nvim_create_augroup(group_name, { clear = true })

local autocmd = vim.api.nvim_create_autocmd

autocmd("InsertLeave", {
    group = group_name,
    pattern = "*",
    callback = function()
        if vim.bo.spelllang == "ja" then
            vim.fn.system("zenhan.exe 0")
        end
    end,
})
