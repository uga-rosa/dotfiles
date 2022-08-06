require("mason-lspconfig").setup()

local function formatting(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

local on_attach = function(client, bufnr)
    local buf_map = function(lhs, rhs)
        utils.keymap.set("n", lhs, rhs, "s", bufnr)
    end

    buf_map("K", "<Cmd>Lspsaga hover_doc<CR>")
    buf_map("[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
    buf_map("]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
    buf_map("<leader>n", "<Cmd>Lspsaga rename<CR>")
    buf_map("<leader>a", "<Cmd>Lspsaga code_action<CR>")
    buf_map("<C-f>", function()
        return require("lspsaga.action").smart_scroll_with_saga(1)
    end)
    buf_map("<C-b>", function()
        return require("lspsaga.action").smart_scroll_with_saga(-1)
    end)

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                formatting(bufnr)
            end,
        })
    end
end

local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
local opts = { capabilities = capabilities, on_attach = on_attach }

require("mason-lspconfig").setup_handlers({
    function(server_name)
        lspconfig[server_name].setup(opts)
    end,
    ["sumneko_lua"] = function()
        local dev = require("lua-dev").setup({
            library = {
                vimruntime = true,
                types = true,
                plugins = { "plenary.nvim" },
            },
            snippet = false,
            lspconfig = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "utils" },
                        },
                    },
                },
            },
        })
        lspconfig.sumneko_lua.setup(dev)
    end,
})
