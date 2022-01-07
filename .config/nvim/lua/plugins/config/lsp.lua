local lspinstaller = require("nvim-lsp-installer")

local map = vim_api.map
local augroup = vim_api.augroup
local command = vim.api.nvim_add_user_command

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
command("Format", vim.lsp.buf.formatting_sync, {})

-- LSP setting
local opts = {
    default = {
        capabilities = capabilities,
        on_attach = function()
            -- auto formatting
            vim_api.augroup({ format = { "BufWritePre", "<buffer>", "Format" } })
            -- lspsaga
            map("n", "K", "<cmd>Lspsaga hover_doc<cr>", "buffer")
            map("n", "<C-f>", "<cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<cr>", "buffer")
            map("n", "<C-b>", "<cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<cr>", "buffer")
            map("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "buffer")
            map("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "buffer")
            map("n", "<leader>x", "<cmd>Lspsaga code_action<cr>", "buffer")
            map("x", "<leader>x", "<cmd>Lspsaga range_code_action<cr>", "buffer")
            map("n", "<leader>n", "<cmd>Lspsaga rename<cr>", "buffer")
        end,
    },
}

opts.sumneko_lua = require("lua-dev").setup({
    library = {
        vimruntime = true,
        types = true,
        plugins = { "plenary.nvim", "LuaSnip" },
    },
    lspconfig = opts.default,
})
-- disable completion snippet
opts.sumneko_lua.settings.Lua.completion = nil

opts.bashls = setmetatable({
    filetypes = { "sh", "zsh" },
}, { __index = opts.default })

-- automatically install
local servers = {
    "sumneko_lua",
    "gopls",
    "pyright",
    "bashls",
    "rust_analyzer",
    "vimls",
}

local installed = {}
for _, server in ipairs(lspinstaller.get_installed_servers()) do
    installed[server.name] = true
end

for _, server in ipairs(servers) do
    if not installed[server] then
        lspinstaller.install(server)
    end
end

-- setup
lspinstaller.on_server_ready(function(server)
    local opt = opts[server.name] or opts.default
    server:setup(opt)
    vim.cmd([[do User LspAttachBuffers]])
end)

-- update command
command("LspUpdateAll", function()
    for _, server in ipairs(lspinstaller.get_installed_servers()) do
        lspinstaller.install(server.name)
    end
end, {})
