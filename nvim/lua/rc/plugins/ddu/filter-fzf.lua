local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "yuki-yano/ddu-filter-fzf",
  dependencies = {
    "ddu.vim",
    "bluz71/vim-nightfly-colors",
  },
  config = function()
    local palette = require("nightfly").palette
    vim.api.nvim_set_hl(0, "DduSearchMatched", { fg = palette.black, bg = palette.emerald })

    helper.patch_global({
      sourceOptions = {
        _ = {
          matchers = { "matcher_fzf" },
          sorters = { "sorter_fzf" },
        },
      },
      filterParams = {
        matcher_fzf = {
          highlightMatched = "DduSearchMatched",
        },
      },
    })
  end,
}

return spec
