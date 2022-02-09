local cmp = require("cmp")
local luasnip = require("luasnip")
local feedkey = utils.feedkey

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

local function updown(dir)
    return function()
        if luasnip.choice_active() then
            luasnip.change_choice(dir)
        elseif cmp.visible() then
            if dir == 1 then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            end
        else
            if dir == 1 then
                feedkey("<C-n>")
            else
                feedkey("<C-p>")
            end
        end
    end
end

cmp.setup({
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
                nvim_lsp_signature_help = "[SignatureHelp]",
                nvim_lua = "[NvimLua]",
                luasnip = "[LuaSnip]",
                dictionary = "[Dictionary]",
            })[entry.source.name]
            vim_item.dup = ({
                buffer = 0,
                dictionary = 0,
                nvim_lua = 0,
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
            i = updown(1),
            s = updown(1),
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    feedkey("<Down>")
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            i = updown(-1),
            s = updown(-1),
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    feedkey("<Up>")
                end
            end,
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "treesitter", group_index = 1 },
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
            group_index = 2,
        },
        {
            name = "dictionary",
            keyword_length = 2,
            priority = 1,
            group_index = 2,
        },
        { name = "path", group_index = 2 },
    },
})

cmp.setup.cmdline("/", {
    sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline" },
        { name = "path" },
    },
})

require("cmp_dictionary").setup({
    dic = {
        ["*"] = "/usr/share/dict/words",
        ["autohotkey"] = "~/dotfiles/doc/ahk.dict",
    },
    exact = 2,
    first_case_insensitive = true,
})

vim.cmd([[autocmd FileType * lua require("cmp_dictionary").update()]])

local api = vim.api

local function get_cursor(bufnr)
    local row, col = unpack(api.nvim_win_get_cursor(bufnr or 0))
    return row - 1, col
end

local function get_line(bufnr, lnum)
    return api.nvim_buf_get_lines(bufnr or 0, lnum, lnum + 1, false)[1] or ""
end

local function get_current_line(bufnr)
    local row = unpack(api.nvim_win_get_cursor(0)) or 1
    return get_line(bufnr, row - 1)
end

cmp.event:on("confirm_done", function(evt)
    local opt = {
        map_char = { tex = "" },
        kinds = {
            cmp.lsp.CompletionItemKind.Method,
            cmp.lsp.CompletionItemKind.Function,
        },
    }

    local entry = evt.entry
    local line = get_current_line()
    local _, col = get_cursor()
    local prev_char = line:sub(col, col)
    local next_char = line:sub(col + 1, col + 1)
    local item = entry:get_completion_item()

    local char = opt.map_char[vim.bo.filetype] or "("

    if
        char == ""
        or prev_char == char
        or next_char == char
        or (not vim.tbl_contains(opt.kinds, item.kind))
        or (item.textEdit and item.textEdit.newText and item.textEdit.newText:match("[%(%[]"))
        or (item.insertText and item.insertText:match("[%(%[]"))
    then
        return
    end

    feedkey(char, "i")
end)
