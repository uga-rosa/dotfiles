---@type LazySpec
local spec = {
  {
    "vim-skk/skkeleton",
    dependencies = {
      {
        "delphinus/skkeleton_indicator.nvim",
        config = function()
          require("skkeleton_indicator").setup()
        end,
      },
    },
    config = function()
      vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")

      vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsPluginPost:skkeleton",
        callback = function()
          vim.g["skkeleton#mapped_keys"] = { "<c-l>" }
          vim.fn["skkeleton#register_keymap"]("input", "<c-q>", "katakana")
          vim.fn["skkeleton#register_keymap"]("input", "<c-l>", "zenkaku")
          vim.fn["skkeleton#register_keymap"]("input", "'", "henkanPoint")
          local path = vim.fn.stdpath("config") .. "/script/azik_skkeleton.json"
          local buffer = vim.fs.read(path)
          local kanaTable = vim.json.decode(buffer)
          kanaTable[" "] = "henkanFirst"
          kanaTable["/"] = "abbrev"
          vim.fn["skkeleton#register_kanatable"]("azik", kanaTable, true)

          local lazy_root = require("lazy.core.config").options.root
          vim.fn["skkeleton#config"]({
            kanaTable = "azik",
            eggLikeNewline = true,
            globalDictionaries = {
              vim.fs.joinpath(lazy_root, "dict", "SKK-JISYO.L"),
            },
            userJisyo = "~/.secret/SKK-JISYO.user",
            markerHenkan = "<>",
            markerHenkanSelect = ">>",
            registerConvertResult = true,
          })
        end,
      })
    end,
  },
  {
    "skk-dev/dict",
    cond = false,
  },
  {
    dir = "~/plugin/skk-learning.nvim",
    cond = false,
  },
}

return spec
