local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")
local array = require("steel.array")

local augroup = vim_api.augroup
local command = vim_api.command
local map = vim_api.map

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
            require("lsp_signature").on_attach({
                toggle_key = "<C-e>",
            })
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

-- automatically install
local installed = array.map(lspinstaller.get_installed_servers(), function(server)
    return server.name
end)

array.new({
    "sumneko_lua",
    "gopls",
    "pyright",
    "bashls",
    "rust_analyzer",
    "vimls",
})
    :filter(function(server)
        return not installed:contains(server)
    end)
    :map(function(server)
        lspinstaller.install(server)
    end, true)

-- setup
lspinstaller.on_server_ready(function(server)
    local opt = opts[server.name] or opts.default
    server:setup(opt)
    vim.cmd([[do User LspAttachBuffers]])
end)

-- update command
command({
    "LspUpdateAll",
    function()
        for _, server in ipairs(lspinstaller.get_installed_servers()) do
            lspinstaller.install(server.name)
        end
    end,
})

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
