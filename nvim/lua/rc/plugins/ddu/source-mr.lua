local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "kuuote/ddu-source-mr",
  dependencies = {
    "ddu.vim",
    "lambdalisue/mr.vim",
  },
  init = function()
    vim.keymap.set("n", "<Space>w", "<Cmd>Ddu mrw<CR>")
    vim.keymap.set("n", "<Space>u", "<Cmd>Ddu mru<CR>")
  end,
  config = function()
    for _, kind in ipairs({ "mru", "mrw", "mrr" }) do
      helper.register(kind, function()
        helper.start("file", {
          "mr",
          params = {
            kind = kind,
          },
        })
      end)
    end
  end,
}

return spec
