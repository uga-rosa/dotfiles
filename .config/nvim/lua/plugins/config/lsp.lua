local res, lspinstall = pcall(require, "lspinstall")
local res2, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local res3, lspconfig = pcall(require, "lspconfig")
if not (res and res2 and res3) then
  return
end

local map = utils.map
local command = utils.command
local augroup = utils.augroup

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

opts.bash = {
  filetypes = { "sh", "zsh" },
}

-- automatically install
local servers = { "lua", "rust", "python", "bash", "efm", "vim", "typescript" }

local uninstalled = (function()
  local installed = lspinstall.installed_servers()
  return vim.tbl_filter(function(v)
    return not vim.tbl_contains(installed, v)
  end, servers)
end)()

for _, lsp in ipairs(uninstalled) do
  lspinstall.install_server(lsp)
end

-- reinstall command
command({
  "LspReinstallAll",
  function()
    for _, v in ipairs(lspinstall.installed_servers()) do
      lspinstall.install_server(v)
    end
  end,
})

-- setup
lspinstall.setup()
for _, server in ipairs(lspinstall.installed_servers()) do
  local opt = opts[server] or default
  lspconfig[server].setup(opt)
end

-- format
command({ "-bar", "Format", vim.lsp.buf.formatting_sync })
augroup({
  format = {
    { "BufWritePre", "*.lua,*.py", "Format" },
    { "BufWritePost", "*.json", "Format|w" },
  },
})

-- mapping
map("n", "K", "lua vim.lsp.buf.hover()", { "noremap", "cmd" })
map("n", "[d", "lua vim.lsp.diagnostic.goto_prev()", { "noremap", "cmd" })
map("n", "]d", "lua vim.lsp.diagnostic.goto_next()", { "noremap", "cmd" })

-- sign
-- same with galaxyline
vim.cmd([[
highlight LspDiagnosticsSignError guifg=#fc514e
highlight LspDiagnosticsSignWarning guifg=#f78c6c
highlight LspDiagnosticsSignHint guifg=#7fdbca
highlight LspDiagnosticsSignInformation guifg=#82aaff
sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation
]])
