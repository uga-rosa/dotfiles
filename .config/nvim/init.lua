local config = {
  "utils",
  "core.options",
  "core.mappings",
}

for _, v in ipairs(config) do
  require(v)
end

require("myplug").setup()

vim.g.nightflyItalics = false
pcall(vim.cmd, "colorscheme nightfly")
