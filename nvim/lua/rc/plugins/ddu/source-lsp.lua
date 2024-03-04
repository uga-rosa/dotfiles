local helper = require("rc.helper.ddu")

helper.ff_map("lsp", function(map)
  map("<C-x>", helper.item_action("open", { command = "split" }))
  map("<C-v>", helper.item_action("open", { command = "vsplit" }))
  map("q", helper.item_action("quickfix"))
  map("l", helper.action("expandItem"))
  map("h", helper.action("collapseItem"))
end)

helper.ff_filter_map("lsp", function(map)
  map("i", "<C-x>", helper.item_action("open", { command = "split" }, true))
  map("i", "<C-v>", helper.item_action("open", { command = "vsplit" }, true))
end)

---@type PluginSpec
local spec = {
  "uga-rosa/ddu-source-lsp",
  dev = true,
  dependencies = "ddu.vim",
  init = function()
    vim.keymap.set("n", "gd", "<Cmd>Ddu lsp:definition<CR>")
    vim.keymap.set("n", "gr", "<Cmd>Ddu lsp:references<CR>")
    vim.keymap.set({ "n", "x" }, "<Space>a", "<Cmd>Ddu lsp:code_action<CR>")

    vim.g.ddu_source_lsp_clientName = "nvim-lsp"
  end,
  config = function()
    helper.patch_global({
      kindOptions = {
        lsp = {
          defaultAction = "open",
        },
        lsp_codeAction = {
          defaultAction = "apply",
        },
      },
    })

    for name, method in pairs({
      ["lsp:declaration"] = "textDocument/declaration",
      ["lsp:definition"] = "textDocument/definition",
      ["lsp:type_definition"] = "textDocument/typeDefinition",
      ["lsp:implementation"] = "textDocument/implementation",
    }) do
      helper.patch_local(name, {
        sources = {
          {
            name = "lsp_definition",
            params = {
              method = method,
            },
          },
        },
        sync = true,
        uiParams = {
          ff = {
            immediateAction = "open",
          },
        },
      })
    end

    helper.patch_local("lsp:references", {
      sources = { "lsp_references" },
    })

    ---@param word string
    ---@param color string
    ---@return { name: string, params: table }
    local function separator(word, color)
      local hlGroup = "DduDummy" .. color:gsub("[^a-zA-Z0-9]", "")
      vim.api.nvim_set_hl(0, hlGroup, { fg = color })
      return {
        name = "dummy",
        params = { word = word, hlGroup = hlGroup },
      }
    end

    helper.patch_local("lsp:definition_all", {
      sources = {
        separator(">>Definition<<", "#fc514e"),
        { name = "lsp_definition", params = { method = "textDocument/definition" } },
        separator(">>Type definition<<", "#ffcb8b"),
        { name = "lsp_definition", params = { method = "textDocument/typeDefinition" } },
        separator(">>Declaration<<", "#21c7a8"),
        { name = "lsp_definition", params = { method = "textDocument/declaration" } },
        separator(">>Implementation<<", "#5e97ec"),
        { name = "lsp_definition", params = { method = "textDocument/implementation" } },
      },
    })

    helper.patch_local("lsp:finder", {
      sources = {
        separator(">>Definition<<", "#fc514e"),
        { name = "lsp_definition" },
        separator(">>References<<", "#5e97ec"),
        { name = "lsp_references", params = { includeDeclaration = false } },
      },
    })

    helper.patch_local("lsp:document_symbol", {
      sources = {
        {
          name = "lsp_documentSymbol",
          options = {
            converters = { "converter_lsp_symbol" },
          },
        },
      },
      uiParams = {
        ff = {
          displayTree = true,
        },
      },
    })

    helper.patch_local("lsp:dynamic_workspaceSymbol", {
      sources = {
        {
          name = "lsp_workspaceSymbol",
          options = { volatile = true },
        },
      },
      uiParams = {
        ff = {
          ignoreEmpty = false,
        },
      },
    })

    for name, method in pairs({
      ["lsp:incoming_call"] = "callHierarchy/incomingCalls",
      ["lsp:outgoing_call"] = "callHierarchy/outgoingCalls",
      ["lsp:super_type"] = "typeHierarchy/supertypes",
      ["lsp:sub_type"] = "typeHierarchy/subtypes",
    }) do
      helper.patch_local(name, {
        sources = {
          {
            name = "lsp_callHierarchy",
            params = { method = method },
          },
        },
        uiParams = {
          ff = {
            displayTree = true,
            startFilter = false,
          },
        },
      })
    end

    for subcommand, buffer in pairs({
      lsp_diagnostic = 0,
      lsp_diagnostic_all = vim.NIL,
    }) do
      helper.patch_local(subcommand, {
        sources = {
          {
            name = "lsp_diagnostic",
            params = { buffer = buffer },
          },
        },
        sourceOptions = {
          lsp_diagnostic = {
            converters = {
              {
                name = "converter_lsp_diagnostic",
                params = {
                  iconMap = {
                    Error = "Error 󰅚 ",
                    Warning = "Warn 󰀪 ",
                    Info = "Info 󰌶 ",
                    Hint = "Hint  ",
                  },
                },
              },
            },
          },
        },
      })
    end

    helper.patch_local("lsp:code_action", {
      sources = { "lsp_codeAction" },
    })
  end,
}

return spec
