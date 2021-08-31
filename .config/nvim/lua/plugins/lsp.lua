local res, lspinstall = pcall(require, "lspinstall")
local res2, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local res3, lspconfig = pcall(require, "lspconfig")
if not (res and res2 and res3) then
  return
end

local map = utils.map
local set = utils.set

-- cmp source
cmp_nvim_lsp.setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

local default = {
  capabilities = capabilities,
}

local opts = {}
opts.lua = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "jit", "package", "utils", "Luasnip_current_nodes" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
  capabilities = capabilities,
}
opts.efm = {
  filetypes = { "markdown", "json", "lua", "python", "sh", "yaml" },
  capabilities = capabilities,
}

-- automatically install
local servers = set.new({ "lua", "rust", "python", "bash", "efm", "vim" })
local uninstalled = servers:diff(lspinstall.installed_servers())
for _, lsp in ipairs(uninstalled) do
  lspinstall.install_server(lsp)
end

-- setup
local setup_servers = function()
  lspinstall.setup()
  for _, server in ipairs(lspinstall.installed_servers()) do
    local opt = opts[server] or default
    lspconfig[server].setup(opt)
  end
end

setup_servers()

lspinstall.post_install_hook = function()
  setup_servers()
  vim.cmd([[bufdo e]])
end

-- format
vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()")

-- mapping
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "noremap")
map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "noremap")
map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "noremap")

-- sign
vim.cmd([[
sign define LspDiagnosticsSignError text=
sign define LspDiagnosticsSignWarning text=
sign define LspDiagnosticsSignInformation text=
sign define LspDiagnosticsSignHint text=
]])

-- rename in floating window
require("config.rename")
