local helper = require("rc.helper.ddc")

---@type PluginSpec
local spec = {
  "Shougo/ddc-source-vim",
  dependencies = {
    "ddc.vim",
    "Shougo/neco-vim",
  },
  config = function()
    helper.patch_global({
      sourceOptions = {
        vim = {
          mark = "[Vim]",
        },
      },
    })
  end,
}

return spec
