local config = {
  "utils",
  "core.options",
  "core.mappings",
}

for _, v in ipairs(config) do
  require(v)
end

vim.cmd([[
silent! command PackerCompile lua require('plugins.list') require('packer').compile()
silent! command PackerInstall lua require('plugins.list') require('packer').install()
silent! command PackerStatus lua require('plugins.list') require('packer').status()
silent! command PackerUpdate lua require('plugins.list') require('packer').update()
silent! command PackerSync lua require('plugins.list') require('packer').sync()
]])

vim.cmd("au BufWrite list.lua PackerCompile")

utils.map("n", "<leader>ps", "<cmd>PackerSync<cr>", "noremap")

vim.g.nightflyItalics = 0
vim.cmd("colorscheme nightfly")
