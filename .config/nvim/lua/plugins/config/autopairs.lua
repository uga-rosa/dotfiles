local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
    ignored_next_char = string.gsub([[ [%w%%%[%.] ]], "%s+", ""),
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

vim_api.map("i", "<C-h>", "<bs>")

npairs.add_rules({
    Rule("$", "$", "markdown"),
    Rule("$$", "$$", "markdown"),
})
