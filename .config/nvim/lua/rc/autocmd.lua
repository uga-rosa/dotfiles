local group = "vimrc"
vim.api.nvim_create_augroup(group, { clear = true })

local autocmd = vim.api.nvim_create_autocmd

autocmd("InsertLeave", {
    group = group,
    pattern = "*",
    callback = function()
        if vim.bo.spelllang == "ja" then
            vim.fn.system("zenhan.exe 0")
        end
    end,
})

-- my filetypes
autocmd({ "BufNewFile", "BufRead" }, {
    group = group,
    pattern = "*.ahk,*.inp,*.nim",
    callback = function(arg)
        print(arg.match)
        -- vim.bo.ft = "autohotkey"
    end,
})
