local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  {
    "matsui54/ddu-source-file_external",
    dependencies = "ddu.vim",
    init = function()
      vim.keymap.set("n", "<Space>f", "<Cmd>Ddu files<CR>")
    end,
    config = function()
      helper.register("files", function()
        helper.start("file", {
          "file_external",
          params = {
            cmd = vim.split("fd --type f --color never --hidden --follow --exclude .git", " "),
          },
        })
      end)
    end,
  },
}

return spec
