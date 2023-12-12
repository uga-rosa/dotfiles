local helper = require("rc.helper.lsp")
local utils = require("rc.utils")

local function setupDdc()
  vim.fn["ddc#custom#patch_buffer"]({
    sourceParams = {
      lsp = {
        lspEngine = "lspoints",
      },
    },
  })

  ---@type string[]
  local chars = {}
  for _, client in ipairs(vim.fn["lspoints#get_clients"]()) do
    local provider = client.serverCapabilities.completionProvider
    if provider and provider.triggerCharacters then
      chars = vim.list_extend(chars, provider.triggerCharacters)
    end
  end
  chars = utils.deduplicate(chars)
  for i = #chars, 1, -1 do
    if chars[i]:find("^%s$") then
      table.remove(chars, i)
    end
  end
  table.insert(chars, 1, "[a-zA-Z]")
  local regex = "(?:" .. table.concat(chars, "|\\") .. ")"
  vim.fn["ddc#custom#patch_buffer"]("sourceOptions", {
    ["lsp"] = {
      forceCompletionPattern = regex,
    },
  })
end

---@type LazySpec
local spec = {
  {
    "kuuote/lspoints",
    dependencies = {
      "denops.vim",
    },
    config = function()
      local group = vim.api.nvim_create_augroup("lspoints-attach", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = "LspointsAttach*",
        group = group,
        callback = function(arg)
          setupDdc()
          vim.b.ddu_source_lsp_clientName = "lspoints"

          -- Mappings and commands
          vim.api.nvim_buf_create_user_command(arg.buf, "Rename", function()
            vim.fn["denops#request"]("lspoints", "executeCommand", { "rename", "execute" })
          end, {})
          vim.keymap.set("n", "<Space>n", "<Cmd>Rename<CR>", { buffer = arg.buf })

          vim.api.nvim_buf_create_user_command(arg.buf, "Hover", function()
            vim.fn["denops#request"](
              "lspoints",
              "executeCommand",
              { "hover", "execute", vim.fn.bufnr() }
            )
          end, {})
          vim.keymap.set("n", "K", "<Cmd>Hover<CR>", { buffer = arg.buf })

          vim.api.nvim_buf_create_user_command(arg.buf, "Format", function()
            vim.fn["denops#request"](
              "lspoints",
              "executeCommand",
              { "format", "execute", vim.fn.bufnr() }
            )
          end, {})
          vim.keymap.set("n", "<Space>F", "<Cmd>Format<CR>", { buffer = arg.buf })
        end,
      })

      -- settings
      local function initialize()
        vim.fn["lspoints#load_extensions"]({ "nvim_diagnostics", "format", "hover", "rename" })
        local capabilities = require("ddc_source_lsp").make_client_capabilities()
        vim.fn["lspoints#settings#patch"]({ clientCapabilites = capabilities })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsPluginPost:lspoints",
        callback = initialize,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typescript",
        group = group,
        callback = function(arg)
          local fname = vim.fn.bufname(arg.buf)
          if helper.in_node_repo(fname) then
            return
          end
          require("rc.plugins.lspoints.denols").attach(arg.buf)
        end,
      })

      vim.api.nvim_create_user_command("LspointsReload", function()
        vim.fn["lspoints#reload"]()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DenopsPluginPost:lspoints",
          once = true,
          callback = function(arg)
            initialize()
            local fname = vim.fn.bufname(arg.buf)
            if helper.in_node_repo(fname) then
              return
            end
            require("rc.plugins.lspoints.denols").attach(arg.buf)
          end,
        })
      end, {})
    end,
  },
}

return spec
