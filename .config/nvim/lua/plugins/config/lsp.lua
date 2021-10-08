local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local saga = require("lspsaga")
local sign = require("lsp_signature")

local f = vim.fn
local map = myutils.map
local command = myutils.command
local augroup = myutils.augroup

-- cmp source
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local opts = {
  default = {
    capabilities = capabilities,
    on_attach = function()
      sign.on_attach()
    end,
  },
}

-- local mode = "nvim"
local mode = "5.4"

if mode == "nvim" then
  opts.sumneko_lua = require("lua-dev").setup({
    library = {
      vimruntime = true,
      types = true,
      plugins = false,
    },
    snippet = false,
    lspconfig = opts.default,
  })
elseif mode == "5.4" then
  local path = vim.split(f.expand("$LUA_PATH"), ";")
  local library = {
    [f.expand("~/.luarocks/share/lua/5.4")] = true,
    [f.expand("~/lua/5.4/share")] = true,
  }
  opts.sumneko_lua = setmetatable({
    settings = {
      Lua = {
        runtime = {
          version = "Lua 5.4",
          path = path,
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
end

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
