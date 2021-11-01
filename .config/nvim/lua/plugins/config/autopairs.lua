local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
    ignored_next_char = string.gsub([[ [%w%%%[%.] ]], "%s+", ""),
})

require("nvim-autopairs.completion.cmp").setup({
    map_cr = true,
    map_complete = true,
    auto_select = true,
    insert = false,
})

myutils.map("i", "<C-h>", "<bs>")

npairs.add_rules({
    Rule("$", "$", "markdown"),
    Rule("$$", "$$", "markdown"),
})
