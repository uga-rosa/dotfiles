local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  "Shougo/ddc.vim",
  name = "ddc.vim",
  dependencies = {
    "denops.vim",
    "Shougo/pum.vim",
    "Shougo/ddc-ui-pum",
    "Shougo/ddc-ui-none",
    "tani/ddc-fuzzy",
    {
      "uga-rosa/ddc-previewer-floating",
      dev = true,
    },
  },
  import = "rc.plugins.ddc",
  init = function()
    vim.keymap.set("i", "<C-Space>", function()
      if vim.fn["ddc#visible"]() then
        return vim.fn["ddc#hide"]("Manual")
      elseif vim.bo.filetype == "lua" then
        return vim.fn["ddc#map#manual_complete"]({ sources = { "nvim-lua", "lsp" } })
      elseif #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
        return vim.fn["ddc#map#manual_complete"]({ sources = { "lsp" } })
      else
        return vim.fn["ddc#map#manual_complete"]({ sources = { "buffer", "dictionary" } })
      end
    end, { expr = true, replace_keycodes = false })

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyPluginPost:insx",
      callback = function()
        vim.keymap.set("i", "<CR>", function()
          local info = vim.fn["pum#complete_info"]()
          if info.pum_visible then
            if info.selected >= 0 then
              vim.fn["pum#map#confirm"]()
            else
              return vim.fn["ddc#map#insert_item"](0)
            end
          else
            return vim.fn["insx#expand"]("<CR>")
          end
        end, { silent = true, expr = true, replace_keycodes = false })
      end,
      once = true,
    })
  end,
  config = function()
    vim.fn["pum#set_option"]({
      item_orders = { "kind", "space", "abbr", "space", "menu" },
      scrollbar_char = "┃",
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
          sorters = { "sorter_fuzzy", "exact" },
          converters = { "converter_fuzzy", "converter_lsp-kind" },
          ignoreCase = true,
        },
      },
      sources = helper.sources.default,
    })

    for ft, sources in pairs(helper.sources) do
      if ft ~= "default" and ft ~= "skkeleton" then
        helper.patch_filetype(ft, {
          sources = sources,
        })
      end
    end

    helper.patch_filetype("vim", {
      keywordPattern = "(?:[a-z]:)?\\k*",
    })

    -- source-dictionary {{{
    helper.patch_global({
      sourceOptions = {
        dictionary = {
          mark = "[Dict]",
          matchers = { "matcher_fuzzy" },
        },
      },
      sourceParams = {
        dictionary = {
          paths = { "/usr/share/dict/words" },
          firstCaseInsensitive = true,
        },
      },
    })
    -- }}}

    vim.fn["ddc#enable"]()
    require("ddc_previewer_floating").enable()
  end,
}

return spec
