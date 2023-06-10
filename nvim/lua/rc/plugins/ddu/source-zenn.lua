local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "mikanIchinose/ddu-source-zenn",
    dependencies = "Shougo/ddu.vim",
    config = function()
      helper.register("zenn", function()
        helper.start("file", "zenn", {
          sourceOptions = {
            zenn = {
              converters = {},
            },
          },
        })
      end)
    end,
  },
}

return spec
