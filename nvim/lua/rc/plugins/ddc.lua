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
        dir = "~/plugin/vim-vsnip-integ",
        dependencies = "hrsh7th/vim-vsnip",
        init = function()
          vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
          vim.g.vsnip_choice_delay = 200
          vim.g.vsnip_integ_create_autocmd = false
        end,
      },
      {
        "uga-rosa/ddc-source-nvim-lsp",
        dir = "~/plugin/ddc-source-nvim-lsp",
      },
      {
        "uga-rosa/ddc-source-buffer",
        dir = "~/plugin/ddc-source-buffer",
      },
      "vim-skk/skkeleton",
    },
    import = "rc.plugins.ddc",
    init = function()
      vim.keymap.set({ "i", "c" }, "<C-n>", "<Cmd>call pum#map#insert_relative(+1)<CR>")
      vim.keymap.set({ "i", "c" }, "<C-p>", "<Cmd>call pum#map#insert_relative(-1)<CR>")
      vim.keymap.set(
        { "i", "c" },
        "<C-Space>",
        "pum#visible() ? ddc#hide('Manual') : ddc#map#manual_complete()",
        { expr = true, replace_keycodes = false }
      )
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyPluginPost:lexima",
        callback = function()
          vim.keymap.set("i", "<CR>", function()
            if vim.fn["pum#visible"]() then
              if not vim.fn["pum#entered"]() then
                vim.cmd("noautocmd call pum#map#select_relative(+1)")
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
        pattern = "PumCompleteChanged",
        callback = helper.menu.open,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "PumClose", "PumCompleteDone" },
        callback = helper.menu.close,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "PumCompleteDone", "DdcNvimLspCompleteDone" },
        callback = function(args)
          if
            args.match == "PumCompleteDone"
            and vim.v.completed_item.__sourceName == "nvim-lsp"
          then
            return
          end
          vim.fn["vsnip_integ#on_complete_done"](vim.v.completed_item)
        end,
      })
    end,
    config = function()
      local sources = {
        default = { "vsnip", "nvim-lsp", "buffer" },
        skkeleton = { "skkeleton" },
      }

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
        keywordPattern = [[(?:-?\d+(?:\.\d+)?|[a-zA-Z_]\w*(?:-\w*)*)]],
        sources = sources.default,
        sourceOptions = {
          _ = {
            minAutoCompleteLength = 1,
            matchers = { "matcher_fuzzy" },
            sorters = { "sorter_fuzzy" },
            converters = { "converter_fuzzy", "converter_lsp-kind" },
          },
          vsnip = { mark = "[Vsnip]" },
          ["nvim-lsp"] = {
            forceCompletionPattern = [[\.]],
            mark = "[LSP]",
          },
          buffer = { mark = "[Buffer]" },
          skkeleton = {
            mark = "[Skk]",
            matchers = { "skkeleton" },
            sorters = {},
            converters = {},
          },
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

      helper.patch_filetype("vim", {
        keywordPattern = "(?:[a-z]:)?\\k*",
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-enable-post",
        callback = function()
          helper.patch_global("sources", sources.skkeleton)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-disable-post",
        callback = function()
          helper.patch_global("sources", sources.default)
        end,
      })

      vim.fn["ddc#enable"]()
    end,
  },
}

return spec
-- return {}
