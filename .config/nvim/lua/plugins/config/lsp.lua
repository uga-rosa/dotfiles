local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local array = require("steel.array")

local augroup = myutils.augroup
local map = myutils.map

-- lspinfo close
augroup({
  lspinfo_close = {
    "FileType",
    "lspinfo",
    "nnoremap <buffer><nowait> q <cmd>q<cr>",
  },
})

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

-- format command
vim.cmd("command! Format lua vim.lsp.buf.formatting_sync()")

-- LSP setting
local opts = {
  default = {
    capabilities = capabilities,
    on_attach = function()
      -- auto formatting
      vim.cmd("autocmd BufWritePre <buffer> Format")
      -- lspsaga
      map("n", "K", "Lspsaga hover_doc", { "cmd", "buffer" })
      map("n", "<C-f>", "lua require'lspsaga.action'.smart_scroll_with_saga(1)", { "cmd", "buffer" })
      map("n", "<C-b>", "lua require'lspsaga.action'.smart_scroll_with_saga(-1)", { "cmd", "buffer" })
      map("n", "[d", "Lspsaga diagnostic_jump_next", { "cmd", "buffer" })
      map("n", "]d", "Lspsaga diagnostic_jump_prev", { "cmd", "buffer" })
      map("n", "<leader>x", "Lspsaga code_action", { "cmd", "buffer" })
      map("x", "<leader>x", "Lspsaga range_code_action", { "cmd", "buffer" })
      map("n", "<leader>rn", "Lspsaga rename", { "cmd", "buffer" })
      -- lsp_signature
      require("lsp_signature").on_attach()
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

opts.bashls = setmetatable({
  filetypes = { "sh", "zsh" },
}, { __index = opts.default })

-- LSP list
local servers = array.new({
  "sumneko_lua",
  "rust_analyzer",
  "pyright",
  "bashls",
  "vimls",
  "clangd",
})

-- automatically install
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
