local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc-source-cmdline",
  dependencies = {
    "ddc.vim",
    "Shougo/ddc-source-input",
    "Shougo/ddc-source-cmdline-history",
  },
  config = function()
    helper.patch_global({
      cmdlineSources = {
        [":"] = { "nvim-lua", "cmdline" },
        ["@"] = { "cmdline-history", "input", "buffer" },
        ["="] = { "input" },
      },
      sourceOptions = {
        cmdline = {
          mark = "[Cmd]",
          keywordPattern = "[\\w#:~_-]*",
          matchers = { "matcher_fuzzy" },
          sorters = { "sorter_fuzzy" },
          converters = { "converter_cmdline" },
        },
        input = { mark = "[Input]" },
        ["cmdline-history"] = { mark = "[Hist]" },
      },
    })

    vim.keymap.set({ "n", "x" }, ":", "<Cmd>call ddc#enable_cmdline_completion()<CR>:")
    vim.keymap.set("c", "<Tab>", function()
      if vim.fn["ddc#visible"]() then
        vim.fn["pum#map#insert_relative"](1, "loop")
      else
        return vim.fn["ddc#map#manual_complete"]()
      end
    end, { expr = true, replace_keycodes = false })
    vim.keymap.set("c", "<S-Tab>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
    vim.keymap.set("c", "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
    vim.keymap.set("c", "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
    vim.keymap.set("c", "<C-y>", "<Cmd>call pum#map#confirm()<CR>")
  end,
}

return spec
