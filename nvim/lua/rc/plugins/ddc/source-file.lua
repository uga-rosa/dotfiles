local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "LumaKernel/ddc-source-file",
  dependencies = "ddc.vim",
  config = function()
    helper.patch_global({
      sourceOptions = {
        file = { mark = "[File]" },
      },
      sourceParams = {
        file = {},
      },
    })
  end,
}

return spec
