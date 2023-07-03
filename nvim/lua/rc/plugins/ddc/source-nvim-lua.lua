local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/ddc-source-nvim-lua",
  dev = true,
  dependencies = "ddc.vim",
  config = function()
    helper.patch_global({
      sourceOptions = {
        ["nvim-lua"] = {
          mark = "[Lua]",
          dup = true,
          forceCompletionPattern = "\\.",
        },
      },
    })
  end,
}

return spec
