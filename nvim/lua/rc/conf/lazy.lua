local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  -- stylua: ignore
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }):wait()
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("rc.plugins", {
  change_detection = {
    enabled = false,
  },
})
