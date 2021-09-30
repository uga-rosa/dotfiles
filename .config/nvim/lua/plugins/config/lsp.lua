local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local luadev = require("lua-dev")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local saga = require("lspsaga")
local sign = require("lsp_signature")

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
  on_attach = function()
    sign.on_attach()
  end,
}

local opts = {}

opts.sumneko_lua = {
  luadev.setup({
    library = {
      plugins = false,
    },
    lspconfig = default,
  }),
}

opts.efm = setmetatable({
  filetypes = { "json", "lua", "python", "sh" },
}, { __index = default })

opts.bashls = setmetatable({
  filetypes = { "sh", "zsh" },
}, { __index = default })

opts.hls = setmetatable({
  settings = {
    haskell = {
      formattingProvider = "stylish-haskell",
    },
  },
}, {
  __index = default,
})

-- automatically install
local servers = {
  "sumneko_lua",
  "rust_analyzer",
  "pyright",
  "bashls",
  -- "hls",
  "efm",
  "vimls",
}

local installed = vim.tbl_map(function(server)
  return server.name
end, lspinstaller.get_installed_servers())

for _, server in ipairs(servers) do
  if not vim.tbl_contains(installed, server) then
    lspinstaller.install(server)
  end
end

-- setup
lspinstaller.on_server_ready(function(server)
  local opt = opts[server.name] or default
  server:setup(opt)
  vim.cmd([[do User LspAttachBuffers]])
end)

-- Nim (manual installed)
lspconfig.nimls.setup(default)

-- format
local nim_format = function()
  vim.loop.spawn(
    "nimpretty",
    { args = { "--indent:2", "--maxLineLen:120", vim.fn.expand("%:p") } },
    vim.schedule_wrap(function(code, _)
      if code == 0 then
        vim.cmd("e")
        print("Format success")
      else
        print("Format failure")
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
    { "BufWritePre", "*.lua,*.py,*.hs,*.json", "Format" },
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
