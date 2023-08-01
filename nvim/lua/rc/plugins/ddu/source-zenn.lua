local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "kyoh86/ddu-source-zenn_dev",
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "<Space>z", "<Cmd>Ddu zenn<CR>")
  end,
  config = function()
    helper.register("zenn", function()
      helper.start("file", {
        "zenn_dev_article",
        params = {
          slug = false,
        },
        options = {
          path = vim.fs.normalize("~/zenn"),
          converters = {},
        },
      })
    end)
  end,
}

return spec
