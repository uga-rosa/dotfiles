local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local sign = require("lsp_signature")
local array = require("steel.array")

local map = myutils.map
local command = myutils.command
local augroup = myutils.augroup

-- cmp source
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- lsp saga
require("lspsaga").setup({
  error_sign = " ",
  warn_sign = " ",
  hint_sign = " ",
  infor_sign = " ",
  code_action_prompt = {
    enable = false,
  },
  code_action_keys = {
    quit = { "<C-c>", "<esc>", "q" },
    exec = "<cr>",
  },
  rename_action_keys = {
    quit = { "<C-c>", "<esc>" },
    exec = "<cr>",
  },
})

local opts = {
  default = {
    capabilities = capabilities,
    on_attach = function()
      -- lsp_signature
      sign.on_attach()
      -- lspsaga
      map("n", "K", "Lspsaga hover_doc", { "cmd", "buffer" })
      map("n", "<C-f>", "lua require'lspsaga.action'.smart_scroll_with_saga(1)", { "cmd", "buffer" })
      map("n", "<C-b>", "lua require'lspsaga.action'.smart_scroll_with_saga(-1)", { "cmd", "buffer" })
      map("n", "[d", "Lspsaga diagnostic_jump_next", { "cmd", "buffer" })
      map("n", "]d", "Lspsaga diagnostic_jump_prev", { "cmd", "buffer" })
      map("n", "<leader>x", "Lspsaga code_action", { "cmd", "buffer" })
      map("x", "<leader>x", "Lspsaga range_code_action", { "cmd", "buffer" })
      map("n", "<leader>rn", "Lspsaga rename", { "cmd", "buffer" })
    end,
  },
}

opts.sumneko_lua = require("lua-dev").setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = { "steelarray.nvim" },
  },
  lspconfig = opts.default,
})

opts.efm = setmetatable({
  filetypes = { "json", "lua", "python", "sh", "zsh" },
}, { __index = opts.default })

opts.bashls = setmetatable({
  filetypes = { "sh", "zsh" },
}, { __index = opts.default })

-- automatically install
local servers = array.new({
  "sumneko_lua",
  "rust_analyzer",
  "pyright",
  "bashls",
  "efm",
  "vimls",
})

local installed = array.new(lspinstaller.get_installed_servers()):map(function(server)
  return server.name
end)

servers
  :filter(function(server)
    return not installed:contain(server)
  end)
  :map(function(server)
    lspinstaller.install(server)
  end)

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

-- Julia (manual installed)
lspconfig.julials.setup(opts.default)

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
