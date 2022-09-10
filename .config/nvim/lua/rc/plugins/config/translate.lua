local map = Keymap.set

local prefix = "m"
local target2map = {
    JA = "j",
    EN = "e",
}

local function mapping(suffix, opt)
    local function builder(target, source)
        return "<Cmd>Translate " .. target .. " -source=" .. source .. " " .. opt .. "<CR><ESC>"
    end
    -- Japanese to English
    local lhs = prefix .. target2map["EN"] .. suffix
    local rhs = builder("EN", "JA")
    map("nx", lhs, rhs, "s")
    -- English to Japanese
    lhs = prefix .. target2map["JA"] .. suffix
    rhs = builder("JA", "EN")
    map("nx", lhs, rhs, "s")
end

mapping("f", "-parse_after=window -output=floating")
mapping("s", "-output=split")
mapping("i", "-output=insert")
mapping("r", "-output=replace")
mapping("c", "-comment")

require("translate").setup({
    default = {
        command = "translate_shell",
    },
    preset = {
        output = {
            split = {
                append = true,
            },
        },
    },
})

vim.api.nvim_create_augroup("translate-nvim-user", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "translate-nvim-user",
    pattern = "translate",
    callback = function()
        map("n", "q", "<Cmd>quit<CR>", "bn")
    end,
})
