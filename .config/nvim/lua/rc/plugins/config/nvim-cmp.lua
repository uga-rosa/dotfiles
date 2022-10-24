local api = vim.api

local cmp = require("cmp")
local luasnip = require("luasnip")
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

local function cmp_down()
    if luasnip.choice_active() then
        cmp.close()
        luasnip.change_choice(1)
    elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    else
        feedkey("<C-n>")
    end
end

local function cmp_up()
    if luasnip.choice_active() then
        cmp.close()
        luasnip.change_choice(-1)
    elseif cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    else
        feedkey("<C-p>")
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
        ["<C-n>"] = cmp.mapping({
            i = cmp_down,
            s = cmp_down,
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    feedkey("<C-n>")
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            i = cmp_up,
            s = cmp_up,
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    feedkey("<C-p>")
                end
            end,
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "path", group_index = 1 },
        { name = "dynamic", group_index = 1 },
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(api.nvim_list_wins()) do
                        table.insert(bufs, api.nvim_win_get_buf(win))
                    end
                    return bufs
                end,
            },
            group_index = 1,
        },
        {
            name = "dictionary",
            keyword_length = 2,
            priority = 1,
            group_index = 1,
        },
        { name = "latex_symbol", group_index = 2 },
    },
})

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

local Kind = cmp.lsp.CompletionItemKind

local kind_filter = {
    [Kind.Function] = true,
    [Kind.Method] = true,
}

cmp.event:on("confirm_done", function(evt)
    local entry = evt.entry
    local item = entry:get_completion_item()

    if not kind_filter[item.kind] then
        return
    end

    api.nvim_feedkeys("(", "i", true)
end)
