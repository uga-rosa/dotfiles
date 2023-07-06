local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc-source-cmdline",
  dependencies = {
    "ddc.vim",
    "Shougo/ddc-source-input",
    "Shougo/ddc-source-cmdline-history",
  },
  config = function()
    helper.patch_global({
      cmdlineSources = {
        [":"] = { "cmdline", "nvim-lua" },
        ["@"] = { "cmdline-history", "input", "buffer" },
        ["="] = { "input" },
      },
      sourceOptions = {
        cmdline = {
          mark = "[Cmd]",
          keywordPattern = "[\\w#:~_-]*",
          converters = { "converter_cmdline" },
        },
        input = { mark = "[Input]" },
        ["cmdline-history"] = { mark = "[Hist]" },
      },
    })

    vim.keymap.set({ "n", "x" }, ":", "<Cmd>call ddc#enable_cmdline_completion()<CR>:")
  end,
}

return spec
