local helper = require("rc.helper.ddu")

---@type LazySpec
local spec = {
  "kuuote/ddu-source-mr",
  dependencies = {
    "ddu.vim",
    {
      "lambdalisue/mr.vim",
      init = function()
        vim.g["mr#mru#predicates"] = {
          ---@param filename string
          ---@return boolean
          function(filename)
            return not (filename:find("doc/.*%.txt$") or filename:find("doc/.*%.jax$"))
          end,
        }
      end,
    },
  },
  init = function()
    vim.keymap.set("n", "<Space>w", "<Cmd>Ddu file:mrw<CR>")
    vim.keymap.set("n", "<Space>u", "<Cmd>Ddu file:mru<CR>")
  end,
  config = function()
    for _, kind in ipairs({ "mru", "mrw", "mrr" }) do
      helper.patch_local("file:" .. kind, {
        sources = {
          name = "mr",
          options = {
            converters = { "converter_devicon" },
          },
          params = {
            kind = kind,
          },
        },
      })
    end
  end,
}

return spec
