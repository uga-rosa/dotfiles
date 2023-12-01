---@generic T
---@param list T[]
---@return T[]
local function deduplicate(list)
  local set = {}
  local ret = {}
  for _, elem in ipairs(list) do
    if set[elem] == nil then
      set[elem] = true
      table.insert(ret, elem)
    end
  end
  return ret
end

local function setCompletionPattern()
  ---@type string[]
  local chars = {}
  for _, client in ipairs(vim.fn["lspoints#get_clients"]()) do
    local provider = client.serverCapabilities.completionProvider
    if provider and provider.triggerCharacters then
      chars = vim.list_extend(chars, provider.triggerCharacters)
    end
  end
  chars = deduplicate(chars)
  for i = #chars, 1, -1 do
    if chars[i]:find("^%s$") then
      table.remove(chars, i)
    end
  end
  table.insert(chars, 1, "[a-zA-Z]")
  local regex = "(?:" .. table.concat(chars, "|\\") .. ")"
  vim.fn["ddc#custom#patch_buffer"]("sourceOptions", {
    ["nvim-lsp"] = {
      forceCompletionPattern = regex,
    },
  })
end

---@type LazySpec
local spec = {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          -- "vimls",
          -- "gopls",
          -- "bashls",
          -- "vtsls",
          -- "jsonls",
          -- "yamlls",
        },
      })
    end,
  },
  {
    "kuuote/lspoints",
    dependencies = {
      "denops.vim",
    },
    config = function()
      -- mappings
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

      vim.api.nvim_create_user_command("Format", function()
        vim.fn["denops#request"](
          "lspoints",
          "executeCommand",
          { "format", "execute", vim.fn.bufnr() }
        )
      end, {})
      vim.keymap.set("n", "<Space>F", "<Cmd>Format<CR>")

      local group = vim.api.nvim_create_augroup("lspoints-attach", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = "LspointsAttach*",
        group = group,
        callback = function(arg)
          setCompletionPattern()

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
        end,
      })

      -- settings
      local function setup()
        vim.fn["lspoints#load_extensions"]({ "nvim_diagnostics", "format", "hover", "rename" })
        local capabilities = require("ddc_source_lsp").make_client_capabilities()
        vim.fn["lspoints#settings#patch"]({ clientCapabilites = capabilities })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsPluginPost:lspoints",
        callback = setup,
      })

      local servers = {
        typescript = "denols",
        lua = "luals",
        python = "pyright",
        json = "jsonls",
        toml = "taplo",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(servers),
        group = group,
        callback = function(arg)
          require("rc.plugins.lspoints." .. servers[arg.match]).attach(arg.buf)
        end,
      })

      vim.api.nvim_create_user_command("LspointsReload", function()
        vim.fn["lspoints#reload"]()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DenopsPluginPost:lspoints",
          once = true,
          callback = function()
            setup()
            local server = servers[vim.bo.filetype]
            if server then
              require("rc.plugins.lspoints." .. server).attach(0)
            end
          end,
        })
      end, {})
    end,
  },
}

return spec
