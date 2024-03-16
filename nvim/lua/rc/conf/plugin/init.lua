local opts = require("rc.conf.plugin.config").options

-- Bootstrap of jetpack
local jetpack_root = vim.fs.joinpath(opts.root, "vim-jetpack")
if not vim.fs.isdir(jetpack_root) then
  -- stylua: ignore
  vim.system({
    "curl",
    "-fLo",
    vim.fs.joinpath(jetpack_root, "plugin", "jetpack.vim"),
    "--create-dirs",
    "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim",
  }):wait()
end
vim.cmd("packadd vim-jetpack")
vim.g.jetpack_njobs = 100

require("rc.conf.plugin.loader").run("rc.plugins")
