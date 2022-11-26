local api = vim.api

require("mason-lspconfig").setup({
  ensure_installed = {
    "sumneko_lua",
    "pyright",
    "bashls",
    "gopls",
    "nimls",
    "vimls",
    "cssls",
  },
})

local function on_attach(_, bufnr)
  local buf_map = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
  end

  buf_map("K", "<Cmd>Lspsaga hover_doc<CR>")
  buf_map("[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
  buf_map("]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
  buf_map("<leader>n", "<Cmd>Lspsaga rename<CR>")
  buf_map("<leader>a", "<Cmd>Lspsaga code_action<CR>")

  api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
  end, {})
  buf_map("<leader>F", "<Cmd>Format<CR>")
end

---@param plugins string[]
---@return string[]
local function library(plugins)
  local ret = {}

  for _, plugin in ipairs(plugins) do
    local path = vim.fn["dein#get"](plugin).path
    if vim.bool_fn.isdirectory(path .. "/lua") then
      table.insert(ret, path)
    end
  end

  table.insert(ret, vim.fn.stdpath("config"))

  return ret
end

local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local opts = { capabilities = capabilities, on_attach = on_attach }

require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup(opts)
  end,
  ["sumneko_lua"] = function()
    local lua_opts = {
      settings = {
        Lua = {
          format = {
            enable = false,
          },
          diagnostics = {
            globals = { "vim", "describe", "it" },
          },
          runtime = {
            version = "LuaJIT",
            path = { "lua/?.lua", "lua/?/init.lua" },
          },
          workspace = {
            library = library({ "plenary.nvim", "nvim-cmp", "sqlite.lua" }),
            checkThirdParty = false,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.sumneko_lua.setup(lua_opts)
  end,
})

-- Deno
lspconfig.denols.setup(opts)

-- Diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = false,
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})
