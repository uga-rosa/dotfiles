local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "kyoh86/ddu-source-lazy_nvim",
  dependencies = { "ddu.vim" },
  init = function()
    vim.keymap.set("n", "<Space>p", "<Cmd>Ddu lazy<CR>")
  end,
  config = function()
    helper.patch_local("lazy", {
      sources = { "lazy_nvim" },
      kindOptions = {
        _ = {
          defaultAction = "browse",
        },
      },
    })
  end,
}

return spec
