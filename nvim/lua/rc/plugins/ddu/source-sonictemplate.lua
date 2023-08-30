local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "uga-rosa/ddu-source-sonictemplate",
  dev = true,
  dependencies = "ddu.vim",
  config = function()
    helper.patch_local("sonictemplate", {
      sources = {
        {
          name = "sonictemplate",
          options = {
            defaultAction = "apply",
          },
        },
      },
    })
  end,
}

return spec
