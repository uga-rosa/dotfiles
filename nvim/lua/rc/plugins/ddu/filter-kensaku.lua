local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "Milly/ddu-filter-kensaku",
  dependencies = {
    "ddu.vim",
    "kensaku.vim",
  },
  config = function()
    helper.patch_global({
      filterParams = {
        matcher_kensaku = {
          highlightMatched = "Search",
        },
      },
    })
  end,
}

return spec
