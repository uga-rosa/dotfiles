vim.g.quickrun_config = {
    _ = {
        runner = "neovim_job",
        outputter = "buffer",
        ["outputter/buffer/opener"] = "botright 10sp",
        ["outputter/buffer/close_on_empty"] = true,
    },
    nim = {
        command = "nim",
        cmdopt = "r",
        exec = "%c %o -d:release",
    },
    nimble = {
        command = "nimble",
        cmdopt = "run",
        exec = "%c %o",
    },
}

local map = myutils.map
local aug = myutils.augroup

map("n", "@r", { "w", "QuickRun" }, "cmd")
aug({
    quickrun_quit = {
        "BufEnter",
        "quickrun://output",
        function()
            map("n", "q", "quit", { "nowait", "buffer", "cmd" })
        end,
    },
    luafile = {
        "FileType",
        "lua",
        function()
            map("n", "@R", { "w", "luafile %" }, { "cmd", "buffer" })
        end,
    },
})
