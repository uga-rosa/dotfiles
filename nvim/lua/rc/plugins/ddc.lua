local helper = require("rc.helper.ddc")

---@type LazySpec
local spec = {
  {
    "hrsh7th/vim-vsnip",
    init = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
      vim.g.vsnip_choice_delay = 200
    end,
  },
  "tani/ddc-fuzzy",
  {
    "Shougo/ddc-source-nvim-lsp",
    dependencies = {
      {
        "uga-rosa/ddc-nvim-lsp-setup",
        dev = true,
      },
      "neovim/nvim-lspconfig",
    },
    dev = true,
    config = function()
      require("ddc_nvim_lsp_setup").setup()
    end,
  },
  {
    "uga-rosa/ddc-source-buffer",
    dev = true,
  },
  "LumaKernel/ddc-source-file",
  {
    "Shougo/ddc.vim",
    name = "ddc.vim",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
    },
    init = function()
      vim.keymap.set({ "i", "c" }, "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
      vim.keymap.set({ "i", "c" }, "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
      vim.keymap.set({ "i", "c" }, "<C-Space>", function()
        if vim.fn["pum#visible"]() then
          return vim.fn["ddc#hide"]("Manual")
        else
          return vim.fn["ddc#map#manual_complete"]({ sources = { "nvim-lsp" } })
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
      })

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
        sources = sources.default,
        sourceOptions = {
          _ = {
            minAutoCompleteLength = 1,
            -- Matches either a number that may be negative and/or have a fractional component, or a
            -- string that may start with an alphabet or underscore, and may contain alphanumeric
            -- characters, underscores, or hyphens in a 'kebab-case' style.
            keywordPattern = [[(?:-?\d+(?:\.\d+)?|[a-zA-Z_]\w*(?:-\w*)*)]],
            matchers = { "matcher_fuzzy" },
            sorters = { "sorter_fuzzy" },
            converters = { "converter_fuzzy", "converter_lsp-kind" },
          },
          vsnip = { mark = "[Vsnip]" },
          ["nvim-lsp"] = {
            mark = "[LSP]",
            dup = "keep",
            ignoreCase = true,
          },
          file = {
            mark = "[File]",
          },
          buffer = { mark = "[Buffer]" },
          skkeleton = {
            mark = "[Skk]",
            matchers = { "skkeleton" },
            sorters = {},
            converters = {},
            isVolatile = true,
          },
        },
        sourceParams = {
          ["nvim-lsp"] = {
            snippetEngine = helper.register(function(body)
              vim.fn["vsnip#anonymous"](body)
            end),
            enableResolveItem = true,
            enableAdditionalTextEdit = true,
            confirmBehavior = "insert",
          },
          buffer = {
            getBufnrs = helper.register(function()
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
      helper.menu.enable()
    end,
  },
}

return spec
