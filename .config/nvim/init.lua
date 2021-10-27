pcall(require, "impatient")

local config = {
    "utils",
    "core.options",
    "core.mappings",
}

for _, v in ipairs(config) do
    require(v)
end

require("myplug").setup()

require("packer_compiled")

vim.g.nightflyItalics = false
pcall(vim.cmd, "colorscheme nightfly")
