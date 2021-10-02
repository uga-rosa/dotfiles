local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local saga = require("lspsaga")
local sign = require("lsp_signature")

local f = vim.fn
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

local opts = {
  default = {
    capabilities = capabilities,
    on_attach = function()
      sign.on_attach()
    end,
  },
}

local library = (function()
  local res = {}

  local function add(lib, filter)
    local paths = f.expand(lib, false, true)
    for i = 1, #paths do
      local p = vim.loop.fs_realpath(paths[i])
      if p then
        res[p] = not filter or filter[f.fnamemodify(p, ":h:t")]
      end
    end
  end

  add("$VIMRUNTIME/lua")

  local filter = {
    ["plenary.nvim"] = true,
  }

  add("~/.local/share/nvim/site/pack/*/start/*/lua", filter)
  add("~/.local/share/nvim/site/pack/*/opt/*/lua", filter)

  add("~/.lua/5.4/share")

  return res
end)()

local runtime_path = {}
runtime_path[#runtime_path + 1] = "lua/?.lua"
runtime_path[#runtime_path + 1] = "lua/?/init.lua"
for lib, _ in pairs(library) do
  runtime_path[#runtime_path + 1] = lib .. "/?.lua"
  runtime_path[#runtime_path + 1] = lib .. "/?/init.lua"
end

opts.sumneko_lua = setmetatable({
  settings = {
    Lua = {
      runtime = {
        version = "lua 5.4",
        path = runtime_path,
      },
      workspace = {
        library = library,
      },
      telemetry = { enable = false },
    },
  },
}, {
  __index = opts.default,
})

opts.efm = setmetatable({
  filetypes = { "json", "lua", "python", "sh" },
}, { __index = opts.default })

opts.bashls = setmetatable({
  filetypes = { "sh", "zsh" },
}, { __index = opts.default })

opts.hls = setmetatable({
  settings = {
    haskell = {
      formattingProvider = "stylish-haskell",
    },
  },
}, {
  __index = opts.default,
})

-- automatically install
local servers = {
  "sumneko_lua",
  "rust_analyzer",
  "pyright",
  "bashls",
  "hls",
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
  local opt = opts[server.name] or opts.default
  server:setup(opt)
  vim.cmd([[do User LspAttachBuffers]])
end)

-- Nim (manual installed)
opts.nimls = setmetatable({
  settings = {
    nim = {
      nimprettyMaxLineLen = 120,
    },
  },
}, {
  __index = opts.default,
})
lspconfig.nimls.setup(opts.nimls)

-- format
command({ "Format", vim.lsp.buf.formatting_sync })

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
