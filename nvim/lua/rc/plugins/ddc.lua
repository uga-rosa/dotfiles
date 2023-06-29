local helper = require("rc.helper.ddc")
local utils = require("rc.utils")

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
        "hrsh7th/vim-vsnip",
        init = function()
          vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
          vim.g.vsnip_choice_delay = 200
        end,
      },
      {
        "Shougo/ddc-source-nvim-lsp",
        name = "ddc-source-nvim-lsp",
        dev = true,
      },
      {
        "uga-rosa/ddc-source-buffer",
        dev = true,
      },
      "vim-skk/skkeleton",
    },
    import = "rc.plugins.ddc",
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

      vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
        group = vim.api.nvim_create_augroup("setup-triggerCharacters", {}),
        callback = function()
          local chars = vim
            .iter(vim.lsp.get_active_clients({ bufnr = 0 }))
            :filter(function(client)
              return client.server_capabilities.completionProvider
            end)
            :map(function(client)
              return client.server_capabilities.completionProvider.triggerCharacters or {}
            end)
            :fold({}, function(acc, triggerCharacters)
              return vim.list_extend(acc, triggerCharacters)
            end) --[[@as string[] ]]
          chars = utils.deduplicate(chars)
          for i = #chars, 1, -1 do
            if chars[i]:find("^%s$") then
              table.remove(chars, i)
            end
          end
          table.insert(chars, 1, "[a-zA-Z]")
          local regex = "(?:" .. table.concat(chars, "|\\") .. ")"
          helper.patch_buffer("sourceOptions", {
            ["nvim-lsp"] = {
              forceCompletionPattern = regex,
            },
          })
        end,
      })

      vim.fn["ddc#enable"]()
      helper.menu.enable()
    end,
  },
}

return spec
