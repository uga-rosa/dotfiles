local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "uga-rosa/ddc-source-dictionary",
  dev = true,
  dependencies = { "ddc.vim" },
  config = function()
    local data_dir = vim.fn.stdpath("data") --[[@as string]]
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
          documentCommand = { "wn", "${item.word}", "-over" },
          databasePath = vim.fs.joinpath(data_dir, "ddc-source-dictionary.sqlite3"),
        },
      },
    })
  end,
}

return spec
