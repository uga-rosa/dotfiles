vim.g.quickrun_config = {
    ["_"] = {
        runner = "neovim_job",
        outputter = "error",
        ["outputter/error/success"] = "buffer",
        ["outputter/error/error"] = "quickfix",
        ["outputter/buffer/opener"] = "botright 10sp",
        ["outputter/buffer/close_on_empty"] = true,
    },
}

vim_api.map("n", "@r", "<cmd>QuickRun<cr>")
vim_api.augroup({
    quickrun_quit = { "BufEnter", "quickrun://output", "nnoremap <buffer><nowait> q <cmd>q<cr>" },
})
