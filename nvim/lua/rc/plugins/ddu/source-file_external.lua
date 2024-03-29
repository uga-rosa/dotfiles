local helper = require("rc.helper.ddu")

---@type PluginSpec
local spec = {
  "matsui54/ddu-source-file_external",
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "<Space>f", "<Cmd>Ddu file:find<CR>")
  end,
  config = function()
    helper.patch_local("file:find", {
      sources = {
        {
          name = "file_external",
          options = {
            converters = { "converter_devicon" },
          },
          params = {
            cmd = vim.split("fd --type f --color never", " "),
          },
        },
      },
    })
  end,
}

return spec
