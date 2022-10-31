vim.keymap.set("n", "<M-f>", "<Cmd>Fern . -drawer -toggle<CR>")

vim.api.nvim_create_augroup("my-fern", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fern",
    callback = function(opt)
        local function map(lhs, action)
            local rhs = ("<Plug>(fern-action-%s)"):format(action)
            vim.keymap.set("n", lhs, rhs, { buffer = opt.buf })
        end
        map("<C-x>", "open:split")
        map("<C-v>", "open:vsplit")
    end,
})
