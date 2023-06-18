local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "mikanIchinose/ddu-source-zenn",
    dependencies = "ddu.vim",
    init = function()
      vim.keymap.set("n", "<Space>z", "<Cmd>Ddu zenn<CR>")
    end,
    config = function()
      helper.register("zenn", function()
        helper.start("file", "zenn", {
          sourceOptions = {
            zenn = {
              path = vim.fs.normalize("~/zenn"),
              converters = {},
            },
          },
        })
      end)
    end,
  },
}

return spec
