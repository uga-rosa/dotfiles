local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  {
    "Shougo/ddc.vim",
    name = "ddc.vim",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
      "tani/ddc-fuzzy",
      {
        "hrsh7th/vim-vsnip-integ",
        dependencies = "hrsh7th/vim-vsnip",
        init = function()
          vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
          vim.g.vsnip_choice_delay = 200
        end,
      },
      "uga-rosa/ddc-source-buffer",
    },
    import = "rc.plugins.ddc",
    init = function()
      vim.keymap.set({ "i", "c" }, "<C-n>", function()
        vim.fn["pum#map#insert_relative"](1)
        vim.cmd("do User DdcItemInsert")
      end)
      vim.keymap.set({ "i", "c" }, "<C-p>", function()
        vim.fn["pum#map#insert_relative"](-1)
        vim.cmd("do User DdcItemInsert")
      end)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyPluginPost:lexima",
        callback = function()
          vim.keymap.set("i", "<CR>", function()
            if vim.fn["pum#visible"]() then
              if not vim.fn["pum#entered"]() then
                vim.fn["pum#map#select_relative"](1)
              end
              return vim.fn["pum#map#confirm"]()
            else
              return vim.fn["lexima#expand"]("<CR>", "i")
            end
          end, { silent = true, expr = true, replace_keycodes = false })
        end,
      })
      vim.keymap.set(
        { "i", "s" },
        "<Tab>",
        "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
        { expr = true, replace_keycodes = false }
      )
      vim.keymap.set(
        { "i", "s" },
        "<S-Tab>",
        "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
        { expr = true, replace_keycodes = false }
      )

      vim.api.nvim_create_autocmd("User", {
        pattern = "DdcItemInsert",
        callback = function()
          helper.menu:open()
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "PumClose", "PumCompleteDone" },
        callback = function()
          helper.menu:close()
        end,
      })
    end,
    config = function()
      helper.patch_global({
        ui = "pum",
        autoCompleteEvents = {
          "InsertEnter",
          "TextChangedI",
          "TextChangedP",
          "TextChangedT",
          "CmdlineEnter",
          "CmdlineChanged",
        },
        backspaceCompletion = true,
        sources = { "vsnip", "buffer" },
        sourceOptions = {
          _ = {
            minAutoCompleteLength = 1,
            matchers = { "matcher_fuzzy" },
            sorters = { "sorter_fuzzy" },
            converters = { "converter_fuzzy", "converter_lsp_kind" },
          },
          vsnip = { mark = "[Vsnip]" },
          buffer = { mark = "[Buffer]" },
        },
        sourceParams = {
          buffer = {
            getBufnrs = vim.fn["denops#callback#register"](function()
              -- Visible buffers
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win)
                  return vim.api.nvim_win_get_buf(win)
                end)
                :totable()
            end),
          },
        },
      })

      vim.fn["ddc#enable"]()
    end,
  },
}

return spec
-- return {}
