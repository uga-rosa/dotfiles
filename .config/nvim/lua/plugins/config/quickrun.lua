vim.g.quickrun_config = {
  _ = {
    runner = "neovim_job",
    outputter = "buffer",
    ["outputter/buffer/opener"] = "botright 10sp",
    ["outputter/buffer/close_on_empty"] = true,
  },
  haskell = {
    command = "stack",
    cmdopt = "run",
    exec = "%c %o",
  },
  nim = {
    command = "nimble",
    cmdopt = "run",
    exec = "%c %o",
  },
}

local map = myutils.map
map("n", "@r", { "w", "QuickRun" }, "cmd")
