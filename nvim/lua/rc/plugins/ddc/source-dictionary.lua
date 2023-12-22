local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/ddc-source-dictionary",
  dev = true,
  dependencies = { "ddc.vim" },
  config = function()
    helper.patch_global({
      sourceOptions = {
        dictionary = {
          mark = "[Dict]",
          matchers = { "matcher_fuzzy" },
        },
      },
      sourceParams = {
        dictionary = {
          paths = { "/usr/share/dict/words" },
          firstCaseInsensitive = true,
          documentCommand = { "wn", "{{word}}", "-over" },
        },
      },
    })
  end,
}

return spec
