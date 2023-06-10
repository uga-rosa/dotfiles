local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "mikanIchinose/ddu-source-zenn",
    dependencies = "Shougo/ddu.vim",
    config = function()
      helper.subcommand("zenn", function()
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
