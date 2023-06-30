local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "uga-rosa/ddu-filter-converter_devicon",
  dependencies = "ddu.vim",
  config = function()
    helper.patch_local("file", {
      sourceOptions = {
        _ = {
          converters = { "converter_devicon" },
        },
      },
    })
  end,
}

return spec
