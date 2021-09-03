local fn = vim.fn

local res, packer = pcall(require, "packer")

if not res then
  local packer_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  print("Cloning packer..")
  fn.delete(packer_path, "rf")
  fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    packer_path,
  })

  vim.cmd("packadd packer.nvim")
  res, packer = pcall(require, "packer")

  if res then
    print("Packer cloned successfully")
  else
    print("Couldn't clone packer!\nPacker path: " .. packer_path)
    return
  end
end

packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
  git = {
    clone_timeout = 600,
  },
})

return true
