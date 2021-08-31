local config = {
  "utils",
  "options",
  "mappings",
}

for _, v in ipairs(config) do
  require(v)
end

vim.g.nightflyItalics = 0
vim.cmd("colorscheme nightfly")
