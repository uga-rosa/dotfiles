local helper = require("rc.helper.ddu")

---@type PluginSpec
local spec = {
  "Shougo/ddu-source-action",
  dependencies = "ddu.vim",
  config = function()
    helper.patch_global({
      actionOptions = {
        ["do"] = {
          quit = false,
        },
      },
      kindOptions = {
        action = {
          defaultAction = "do",
        },
      },
    })
  end,
}

return spec
