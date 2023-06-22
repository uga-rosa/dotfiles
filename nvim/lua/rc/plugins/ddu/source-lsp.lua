local helper = require("rc.helper.ddu")

helper.ff_map("lsp", function(map)
  map("<C-x>", helper.item_action("open", { command = "split" }))
  map("<C-v>", helper.item_action("open", { command = "vsplit" }))
  map("q", helper.item_action("quickfix"))
end)

helper.ff_filter_map("lsp", function(map)
  map("i", "<C-x>", helper.item_action("open", { command = "split" }, true))
  map("i", "<C-v>", helper.item_action("open", { command = "vsplit" }, true))
end)

---@type LazySpec
local spec = {
  {
    dir = "~/plugin/ddu-source-lsp",
    dependencies = "ddu.vim",
    init = function()
      vim.keymap.set("n", "gd", "<Cmd>Ddu lsp_definition<CR>")
      vim.keymap.set("n", "gt", "<Cmd>Ddu lsp_type_definition<CR>")
      vim.keymap.set("n", "gr", "<Cmd>Ddu lsp_references<CR>")
      vim.keymap.set({ "n", "x" }, "<Space>a", "<Cmd>Ddu lsp_codeAction<CR>")
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

      for subcommand, method in pairs({
        lsp_declaration = "textDocument/declaration",
        lsp_definition = "textDocument/definition",
        lsp_type_definition = "textDocument/typeDefinition",
        lsp_implementation = "textDocument/implementation",
      }) do
        helper.register(subcommand, function()
          helper.start("lsp", {
            "lsp_definition",
            params = {
              method = method,
            },
          }, {
            sync = true,
            uiParams = {
              ff = {
                immediateAction = "open",
              },
            },
          })
        end)
      end

      helper.register("lsp_references", function()
        helper.start("lsp", "lsp_references")
      end)

      ---@param word string
      ---@param color string
      ---@return Source
      local function separator(word, color)
        local hlGroup = "DduDummy" .. color:gsub("[^a-zA-Z0-9]", "")
        vim.api.nvim_set_hl(0, hlGroup, { fg = color })
        return {
          "dummy",
          params = { word = word, hlGroup = hlGroup },
        }
      end

      helper.register("lsp_definition_all", function()
        helper.start("lsp:dummy", {
          separator(">>Definition<<", "#fc514e"),
          { "lsp_definition", params = { method = "textDocument/definition" } },
          separator(">>Type definition<<", "#ffcb8b"),
          { "lsp_definition", params = { method = "textDocument/typeDefinition" } },
          separator(">>Declaration<<", "#21c7a8"),
          { "lsp_definition", params = { method = "textDocument/declaration" } },
          separator(">>Implementation<<", "#5e97ec"),
          { "lsp_definition", params = { method = "textDocument/implementation" } },
        })
      end)

      helper.register("lsp_finder", function()
        helper.start("lsp:dummy", {
          separator(">>Definition<<", "#fc514e"),
          "lsp_definition",
          separator(">>References<<", "#5e97ec"),
          { "lsp_references", params = { includeDeclaration = false } },
        })
      end)

      helper.patch_local("lsp:symbol", {
        sourceOptions = {
          _ = {
            converters = { "converter_lsp_symbol" },
          },
        },
      })

      helper.register("lsp_document_symbol", function()
        helper.start("lsp:symbol", "lsp_documentSymbol")
      end)

      helper.register("lsp_workspace_symbol", function()
        vim.ui.input({
          prompt = "A query string to filter symbols by: ",
        }, function(input)
          input = input or ""
          helper.start("lsp:symbol", {
            "lsp_workspaceSymbol",
            params = {
              query = input,
            },
          })
        end)
      end)

      helper.register("lsp_dynamic_workspaceSymbol", function()
        helper.start("lsp:symbol", "lsp_workspaceSymbol", {
          uiParams = {
            ff = {
              ignoreEmpty = false,
            },
          },
          sourceOptions = {
            lsp_workspaceSymbol = {
              volatile = true,
            },
          },
        })
      end)

      helper.patch_local("lsp:hierarchy", {
        uiParams = {
          ff = {
            displayTree = true,
            startFilter = false,
          },
        },
      })

      for subcommand, method in pairs({
        lsp_incoming_call = "callHierarchy/incomingCalls",
        lsp_outgoing_call = "callHierarchy/outgoingCalls",
      }) do
        helper.register(subcommand, function()
          helper.start("lsp:hierarchy", {
            "lsp_callHierarchy",
            params = {
              method = method,
            },
          })
        end)
      end

      for subcommand, method in pairs({
        lsp_super_type = "typeHierarchy/supertypes",
        lsp_sub_type = "typeHierarchy/subtypes",
      }) do
        helper.register(subcommand, function()
          helper.start("lsp:hierarchy", {
            "lsp_typeHierarchy",
            params = {
              method = method,
            },
          })
        end)
      end

      for subcommand, buffer in pairs({
        lsp_diagnostic = 0,
        lsp_diagnostic_all = vim.NIL,
      }) do
        helper.register(subcommand, function()
          helper.start("lsp", {
            "lsp_diagnostic",
            params = {
              buffer = buffer,
            },
          })
        end)
      end

      helper.register("lsp_codeAction", function()
        helper.start("codeAction", "lsp_codeAction")
      end)
    end,
  },
}

return spec
