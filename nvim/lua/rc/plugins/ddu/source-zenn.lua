local helper = require("rc.helper.ddu")

---@type PluginSpec
local spec = {
  "kyoh86/ddu-source-zenn_dev",
  dependencies = {
    "ddu.vim",
    "ddu-filter-kensaku",
  },
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
            matchers = { "matcher_kensaku" },
            converters = {},
          },
          params = { slug = false },
        },
      },
    })
  end,
}

return spec
