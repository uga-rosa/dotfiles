local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "uga-rosa/ddu-source-sonictemplate",
  dev = true,
  dependencies = "ddu.vim",
  config = function()
    helper.patch_global({
      kindOptions = {
        sonictemplate = {
          defaultAction = "apply",
        },
      },
    })

    helper.register("sonictemplate", function()
      helper.start("sonictemplate", "sonictemplate", {})
    end)
  end,
}

return spec
