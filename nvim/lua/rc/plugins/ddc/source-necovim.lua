local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/neco-vim",
  dependencies = {
    "ddc.vim",
  },
  config = function()
    helper.patch_global({
      sourceOptions = {
        necovim = {
          mark = "[Vim]",
        },
      },
    })
  end,
}

return spec
