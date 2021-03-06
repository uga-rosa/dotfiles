vim.g.quickrun_config = {
    _ = {
        runner = "neovim_job",
        outputter = "error",
        ["outputter/error/success"] = "buffer",
        ["outputter/error/error"] = "quickfix",
        ["outputter/buffer/opener"] = "botright 10sp",
        ["outputter/buffer/close_on_empty"] = true,
    },
    lua = {
        command = ":luafile",
        exec = "%C %S",
        runner = "vimscript",
    },
    nimble = {
        command = "nimble",
        exec = "%C run",
    },
    nimble_test = {
        command = "nimble",
        exec = "%C test",
    },
}

local map = utils.keymap.set

map("n", "@r", "<Cmd>QuickRun<CR>")
