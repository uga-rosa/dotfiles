vim.g.quickrun_config = {
    _ = {
        runner = "neovim_job",
        outputter = "error",
        ["outputter/error/success"] = "buffer",
        ["outputter/error/error"] = "quickfix",
        ["outputter/buffer/opener"] = "botright 15sp",
        ["outputter/buffer/close_on_empty"] = true,
    },
}

local map = vim_api.map

map("n", "@r", "QuickRun", "cmd")
vim_api.augroup({
    quickrun_quit = {
        "BufEnter",
        "quickrun://output",
        function()
            map("n", "q", "quit", { "nowait", "buffer", "cmd" })
        end,
    },
})
