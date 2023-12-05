local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "kyoh86/ddu-source-zenn_dev",
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "<Space>z", "<Cmd>Ddu file:zenn<CR>")
  end,
  config = function()
    helper.patch_global({
      kindOptions = {
        zenn_dev_article = {
          defaultAction = "open",
        },
      },
    })

    helper.patch_local("file:zenn", {
      sources = {
        {
          name = "zenn_dev_article",
          options = {
            path = vim.fs.normalize("~/zenn"),
            converters = {},
          },
          params = { slug = false },
        },
      },
    })
  end,
}

return spec
