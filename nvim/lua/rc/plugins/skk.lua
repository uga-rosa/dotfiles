local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  {
    "vim-skk/skkeleton",
    dependencies = {
      "denops.vim",
      {
        "delphinus/skkeleton_indicator.nvim",
        config = function()
          require("skkeleton_indicator").setup()
        end,
      },
      "ddc.vim",
    },
    config = function()
      vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")

      vim.fn["denops#plugin#wait_async"]("skkeleton", function()
        vim.g["skkeleton#mapped_keys"] = { "<c-l>" }
        vim.fn["skkeleton#register_keymap"]("input", "<c-q>", "katakana")
        vim.fn["skkeleton#register_keymap"]("input", "<c-l>", "zenkaku")
        vim.fn["skkeleton#register_keymap"]("input", "'", "henkanPoint")
        local path = vim.fn.stdpath("config") .. "/script/azik_skkeleton.json"
        local buffer = uga.fs.read(path)
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
            vim.fs.joinpath(lazy_root, "dict", "SKK-JISYO.jinmei"),
          },
          userDictionary = "~/.secret/SKK-JISYO.user",
          markerHenkan = "<>",
          markerHenkanSelect = ">>",
          registerConvertResult = true,
          sources = { "deno_kv" },
          databasePath = vim.fn.stdpath("data") .. "/skkeleton.db",
        })

        vim.fn["skkeleton#initialize"]()
      end)

      -- Integration with ddc.vim
      helper.patch_global({
        sourceOptions = {
          skkeleton = {
            mark = "[Skk]",
            matchers = { "skkeleton" },
            sorters = {},
            converters = {},
            isVolatile = true,
          },
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-enable-post",
        callback = function()
          helper.patch_buffer("sources", helper.sources.skkeleton)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-disable-post",
        callback = function()
          helper.remove_buffer("sources")
        end,
      })
    end,
  },
  {
    "skk-dev/dict",
    cond = false,
  },
  {
    "uga-rosa/skk-learning",
    dev = true,
    cond = false,
  },
}

return spec
