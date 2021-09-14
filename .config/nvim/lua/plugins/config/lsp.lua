local lspinstall = require("lspinstall")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local luadev = require("lua-dev")
local saga = require("lspsaga")

local map = myutils.map
local command = myutils.command
local augroup = myutils.augroup

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
  filetypes = { "markdown", "json", "lua", "python", "sh" },
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
local nim_format = function()
  vim.loop.spawn(
    "nimpretty",
    { args = { "--indent:2", "--maxLineLen:120", vim.fn.expand("%:p") } },
    vim.schedule_wrap(function(code, _)
      if code == 0 then
        vim.cmd("e")
        -- print("Format success")
        -- else
        -- print("Format failure")
      end
    end)
  )
end

command({
  "-bar",
  "Format",
  function()
    if vim.bo.filetype == "nim" then
      nim_format()
      return
    end
    vim.lsp.buf.formatting_sync()
  end,
})

augroup({
  lspinfo = {
    "FileType",
    "lspinfo",
    "nnoremap <buffer><nowait> q <cmd>bd<cr>",
  },
  format = {
    { "BufWritePre", "*.lua,*.py", "Format" },
    { "BufWritePost", "*.json,*.nim", "Format" },
  },
})

saga.init_lsp_saga({
  error_sign = " ",
  warn_sign = " ",
  hint_sign = " ",
  infor_sign = " ",
  code_action_prompt = {
    enable = false,
  },
  rename_action_keys = {
    quit = { "<C-c>", "<esc>" },
    exec = "<cr>",
  },
})

-- show hover doc
map("n", "K", "Lspsaga hover_doc", "cmd")
-- scroll hover doc
map("n", "<C-f>", "lua require('lspsaga.action').smart_scroll_with_saga(1)", "cmd")
map("n", "<C-b>", "lua require('lspsaga.action').smart_scroll_with_saga(-1)", "cmd")
-- rename
map("n", "<leader>rn", "Lspsaga rename", "cmd")
-- jump diagnostics
map("n", "[d", "Lspsaga diagnostic_jump_next", "cmd")
map("n", "]d", "Lspsaga diagnostic_jump_prev", "cmd")
