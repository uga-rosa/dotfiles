---@type LazySpec
local spec = {
  {
    "uga-rosa/ddu-filter-converter_devicon",
    dependencies = "Shougo/ddu.vim",
    config = function()
      vim.fn["ddu#custom#patch_local"]("file", {
        sourceOptions = {
          _ = {
            converters = { "converter_devicon" },
          },
        },
      })
    end,
  },
}

return spec
