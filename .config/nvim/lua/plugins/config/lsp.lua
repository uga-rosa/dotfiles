local res, lspinstall = pcall(require, "lspinstall")
local res2, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local res3, lspconfig = pcall(require, "lspconfig")
local res4, luadev = pcall(require, "lua-dev")
local res5, saga = pcall(require, "lspsaga")
if not (res and res2 and res3 and res4 and res5) then
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

opts.lua = luadev.setup({
  lspconfig = {
    capabilities = capabilities,
  },
})

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

-- Nim (manual installed)
require("lspconfig").nimls.setup({})

-- format
command({ "-bar", "Format", vim.lsp.buf.formatting_sync })
augroup({
  lspinfo = {
    "FileType",
    "lspinfo",
    "nnoremap <buffer><nowait> q <cmd>bd<cr>",
  },
  format = {
    { "BufWritePre", "*.lua,*.py", "Format" },
    { "BufWritePost", "*.json", "Format|w" },
  },
})

saga.init_lsp_saga({
  use_saga_diagnostic_sign = true,
  error_sign = " ",
  warn_sign = " ",
  hint_sign = " ",
  infor_sign = " ",
})

local action = require("lspsaga.action")

-- show hover doc
map("n", "K", function()
  require("lspsaga.hover").render_hover_doc()
end)
-- scroll hover doc
map("n", "<C-f>", function()
  action.smart_scroll_with_saga(1)
end)
map("n", "<C-b>", function()
  action.smart_scroll_with_saga(-1)
end)
-- rename
map("n", "<leader>r", function()
  require("lspsaga.rename").rename()
end)
-- jump diagnostics
map("n", "[d", function()
  require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()
end)
map("n", "]d", function()
  require("lspsaga.diagnostic").lsp_jump_diagnostic_next()
end)
