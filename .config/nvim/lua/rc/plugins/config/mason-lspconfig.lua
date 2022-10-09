local fn = vim.fn
local api = vim.api
local uv = vim.loop

require("mason-lspconfig").setup()

---@return boolean
local function lua_help()
    if vim.bo.filetype ~= "lua" then
        return false
    end
    ---@type string
    local current_line = api.nvim_get_current_line()
    local cursor_col = api.nvim_win_get_cursor(0)[2] + 1
    -- vim.fn
    local s, e, m = current_line:find("fn%.([%l_]+)%(?")
    if s and s <= cursor_col and cursor_col <= e then
        vim.cmd("h " .. m)
        return true
    end
    -- vim.fn["foo"]
    s, e, m = current_line:find("fn%[['\"]([%w_#]+)['\"]%]%(?")
    if s and s <= cursor_col and cursor_col <= e then
        vim.cmd("h " .. m)
        return true
    end
    -- vim.bool_fn
    s, e, m = current_line:find("bool_fn%.([%l_]+)%(?")
    if s and s <= cursor_col and cursor_col <= e then
        return false
    end
    -- vim.api
    s, e, m = current_line:find("api%.([%l_]+)%(?")
    if s and s <= cursor_col and cursor_col <= e then
        vim.cmd("h " .. m)
        return true
    end
    -- other vim.foo (e.g. vim.validate, vim.lsp.foo, ...)
    s, e, m = current_line:find("(vim%.[%l_%.]+)%(?")
    if s and s <= cursor_col and cursor_col <= e then
        vim.cmd("h " .. m)
        return true
    end
    return false
end

local function on_attach(client, bufnr)
    local buf_map = function(lhs, rhs)
        Keymap.set("n", lhs, rhs, "s", bufnr)
    end

    buf_map("K", function()
        if not lua_help() then
            vim.cmd("Lspsaga hover_doc")
        end
    end)
    buf_map("[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
    buf_map("]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
    buf_map("<leader>n", "<Cmd>Lspsaga rename<CR>")
    buf_map("<leader>a", "<Cmd>Lspsaga code_action<CR>")

    if client.supports_method("textDocument/formatting") then
        api.nvim_create_user_command("Format", function()
            vim.lsp.buf.format()
        end, {})
        buf_map("<leader>F", "<Cmd>Format<CR>")
    end
end

---@param plugins string[]
---@param paths string[]
---@return string[]
local function library(plugins, paths)
    local ret = {}

    ---@param lib string
    ---@param filter? table<string, boolean>
    local function add(lib, filter)
        for _, p in pairs(fn.expand(lib .. "/lua", false, true)) do
            p = uv.fs_realpath(p)
            if p and (not filter or filter[fn.fnamemodify(p, ":h:t")]) then
                table.insert(ret, fn.fnamemodify(p, ":h"))
            end
        end
    end

    add("$VIMRUNTIME")

    local filter = {}
    for _, p in pairs(plugins) do
        filter[p] = true
    end
    for _, site in pairs(vim.split(vim.o.packpath, ",")) do
        add(site .. "/pack/*/start/*", filter)
        add(site .. "/pack/*/opt/*", filter)
    end

    for _, p in pairs(paths) do
        p = fn.expand(p)
        p = uv.fs_realpath(p)
        if fn.filereadable(p) == 1 then
            table.insert(ret, p)
        end
    end

    return ret
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
        local lua_opts = {
            settings = {
                Lua = {
                    format = {
                        enable = false,
                    },
                    diagnostics = {
                        globals = { "vim", "describe", "it" },
                    },
                    runtime = {
                        version = "LuaJIT",
                        path = { "lua/?.lua", "lua/?/init.lua" },
                    },
                    workspace = {
                        library = library(
                            { "plenary.nvim", "nvim-cmp" },
                            { fn.stdpath("config") .. "/lua/utils.lua" }
                        ),
                    },
                },
            },
            capabilities = capabilities,
            on_attach = on_attach,
        }
        lspconfig.sumneko_lua.setup(lua_opts)
    end,
})
