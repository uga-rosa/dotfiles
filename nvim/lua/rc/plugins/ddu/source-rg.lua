local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "shun/ddu-source-rg",
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "<Space>lg", "<Cmd>Ddu file:rg<CR>")
  end,
  config = function()
    helper.patch_local("file:rg", {
      sources = {
        {
          name = "rg",
          options = {
            volatile = true,
            matchers = {},
            converters = { "converter_devicon" },
          },
        },
      },
      uiParams = {
        ff = {
          ignoreEmpty = false,
        },
      },
    })
  end,
}

return spec
