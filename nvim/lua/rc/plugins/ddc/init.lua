local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc.vim",
  name = "ddc.vim",
  dependencies = {
    "vim-denops/denops.vim",
    "Shougo/pum.vim",
    "Shougo/ddc-ui-pum",
    "tani/ddc-fuzzy",
  },
  import = "rc.plugins.ddc",
  init = function()
    vim.keymap.set({ "i", "c" }, "<C-Space>", function()
      if vim.fn["pum#visible"]() then
        return vim.fn["ddc#hide"]("Manual")
      else
        return vim.fn["ddc#map#manual_complete"]()
      end
    end, { expr = true, replace_keycodes = false })
    vim.keymap.set({ "i", "c" }, "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
    vim.keymap.set({ "i", "c" }, "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if vim.bool_fn["vsnip#jumpable"](1) then
        return "<Plug>(vsnip-jump-next)"
      else
        return "<Tab>"
      end
    end, { expr = true, replace_keycodes = true })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if vim.bool_fn["vsnip#jumpable"](-1) then
        return "<Plug>(vsnip-jump-prev)"
      else
        return "<S-Tab>"
      end
    end, { expr = true, replace_keycodes = true })

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyPluginPost:lexima",
      callback = function()
        vim.keymap.set("i", "<CR>", function()
          if vim.fn["pum#visible"]() then
            return vim.fn["pum#map#confirm"]()
          else
            return vim.fn["lexima#expand"]("<CR>", "i")
          end
        end, { silent = true, expr = true, replace_keycodes = false })
      end,
    })
  end,
  config = function()
    vim.fn["pum#set_option"]({
      auto_select = true,
      item_orders = { "kind", "abbr", "menu" },
    })

    helper.patch_global({
      ui = "pum",
      autoCompleteEvents = {
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
        "TextChangedT",
      },
      backspaceCompletion = true,
      sourceOptions = {
        _ = {
          minAutoCompleteLength = 1,
          -- Matches either a number that may be negative and/or have a fractional component, or a
          -- string that may start with an alphabet or underscore, and may contain alphanumeric
          -- characters, underscores, or hyphens in a 'kebab-case' style.
          keywordPattern = [[(?:-?\d+(?:\.\d+)?|[a-zA-Z_]\w*(?:-\w*)*)]],
          matchers = { "exact-prefix", "matcher_fuzzy" },
          sorters = { "sorter_fuzzy" },
          converters = { "converter_fuzzy", "converter_lsp-kind" },
          ignoreCase = true,
        },
      },
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        local ft = vim.bo.filetype
        local sources = helper.sources[ft] or helper.sources.default
        helper.patch_buffer("sources", sources)
      end,
    })

    helper.patch_filetype("vim", {
      keywordPattern = "(?:[a-z]:)?\\k*",
    })

    -- source-menu {{{
    vim.keymap.set("i", "<C-x>", "ddc#map#manual_complete(#{sources: ['menu']})", { expr = true })

    helper.patch_global({
      sourceOptions = {
        menu = {
          forceCompletionPattern = ".*",
        },
      },
      sourceParams = {
        menu = {
          items = {
            { sourceName = "file", lhs = "<C-f>" },
            { sourceName = "buffer", lhs = "<C-b>" },
          },
        },
      },
    })
    -- }}}

    vim.fn["ddc#enable"]()
    helper.menu.enable()
  end,
}

return spec
