local api = vim.api

local cmp = require("cmp")
local luasnip = require("luasnip")

---@param key string
---@param mode? string
local function feedkey(key, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode or "n", true)
end

local lspkind = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

---@param mode string
---@return function
local function cmp_down(mode)
    return function()
        if mode ~= "c" and luasnip.choice_active() then
            cmp.close()
            luasnip.change_choice(1)
        elseif cmp.visible() then
            cmp.select_next_item()
        else
            feedkey("<C-n>")
        end
    end
end

---@param mode string
---@return function
local function cmp_up(mode)
    return function()
        if mode ~= "c" and luasnip.choice_active() then
            cmp.close()
            luasnip.change_choice(-1)
        elseif cmp.visible() then
            cmp.select_prev_item()
        else
            feedkey("<C-p>")
        end
    end
end

local cmp_mapping_down = cmp.mapping({
    i = cmp_down("i"),
    s = cmp_down("s"),
    c = cmp_down("c"),
})

local cmp_mapping_up = cmp.mapping({
    i = cmp_up("i"),
    s = cmp_up("s"),
    c = cmp_up("c"),
})

local function expand_or_jump(fallback)
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    else
        fallback()
    end
end

local function jump_prev(fallback)
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end

local function is_falsy(v)
    return v == nil or v == false or v == 0
end

cmp.setup({
    enabled = function()
        if not is_falsy(vim.g.cmp_disabled) then
            return false
        end
        local disabled = false
        disabled = disabled or (api.nvim_buf_get_option(0, "buftype") == "prompt")
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        return not disabled
    end,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    preselect = cmp.PreselectMode.None,
    completion = {
        get_trigger_characters = function(trigger_characters)
            return vim.tbl_filter(function(char)
                return char ~= " "
            end, trigger_characters)
        end,
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind[vim_item.kind] .. " " .. vim_item.kind
            vim_item.menu = ({
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[NvimLua]",
                luasnip = "[LuaSnip]",
                dictionary = "[Dict]",
                latex_symbol = "[Latex]",
                dynamic = "[Dynamic]",
            })[entry.source.name]
            vim_item.dup = ({
                buffer = 0,
                nvim_lua = 0,
                dictionary = 0,
            })[entry.source.name] or 1
            return vim_item
        end,
    },
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.score,
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find("^_+")
                local _, entry2_under = entry2.completion_item.label:find("^_+")
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under < entry2_under then
                    return true
                elseif entry1_under > entry2_under then
                    return false
                end
            end,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    mapping = {
        ["<C-space>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end, {
            "i",
            "c",
        }),
        ["<C-n>"] = cmp_mapping_down,
        ["<C-p>"] = cmp_mapping_up,
        ["<Tab>"] = cmp.mapping({
            i = expand_or_jump,
            s = expand_or_jump,
            c = function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    cmp.complete()
                end
            end,
        }),
        ["<S-Tab>"] = cmp.mapping({
            i = jump_prev,
            s = jump_prev,
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    cmp.complete()
                end
            end,
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
})

local function get_visible_buffers()
    local bufs = {}
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        local byte_size = api.nvim_buf_get_offset(buf, api.nvim_buf_line_count(buf))
        if byte_size < 1024 * 1024 then
            table.insert(bufs, buf)
        end
    end
    return bufs
end

local function get_sources(name)
    if name == "skkeleton" then
        return {
            { name = "skkeleton" },
        }
    elseif name == "default" then
        return {
            { name = "luasnip" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "nvim_lsp_signature_help" },
            { name = "path" },
            {
                name = "buffer",
                option = {
                    get_bufnrs = get_visible_buffers,
                },
            },
            {
                name = "dictionary",
                keyword_length = 2,
                priority = 1,
            },
        }
    end
end

CmpSourceSelect = function(name)
    local sources = get_sources(name)
    if sources then
        cmp.setup({
            sources = sources,
        })
    end
end

CmpSourceSelect("default")

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline" },
        { name = "path" },
        { name = "dynamic" },
    },
})

cmp.event:on("confirm_done", require("autopairs.cmp").on_confirm_done())
