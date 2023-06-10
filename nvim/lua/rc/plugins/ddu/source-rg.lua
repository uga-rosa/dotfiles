local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "shun/ddu-source-rg",
    dependencies = "Shougo/ddu.vim",
    init = function()
      vim.keymap.set("n", "<Space>lg", "<Cmd>Ddu live_grep<CR>")
    end,
    config = function()
      helper.subcommand("live_grep", function()
        helper.start("file", "rg", {
          uiParams = {
            ff = {
              ignoreEmpty = false,
            },
          },
          sourceOptions = {
            rg = {
              volatile = true,
              matchers = {},
            },
          },
        })
      end)
    end,
  },
}

return spec
