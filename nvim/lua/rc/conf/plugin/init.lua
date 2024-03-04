local data_path = vim.fn.stdpath("data") --[[@as string]]
local plugin_root = vim.fs.joinpath(data_path, "site", "pack", "jetpack", "opt")

-- Bootstrap of jetpack
local jetpack_root = vim.fs.joinpath(plugin_root, "vim-jetpack")
if not vim.fs.isdir(jetpack_root) then
  vim.system({
    "curl",
    "-fLo",
    vim.fs.joinpath(jetpack_root, "plugin", "jetpack.vim"),
    "--create-dirs",
    "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim",
  }):wait()
end
vim.cmd("packadd vim-jetpack")

local config_dir = vim.fn.stdpath("config") --[[@as string]]
local plugin_config_root = vim.fs.joinpath(config_dir, "lua", "rc", "plugins")
require("rc.conf.plugin.loader").run(plugin_config_root)
