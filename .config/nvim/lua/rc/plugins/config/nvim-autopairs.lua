local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup({
    map_c_h = true,
})

require("cmp").event:on(
    "confirm_done",
    require("nvim-autopairs.completion.cmp").on_confirm_done()
)

npairs.add_rules({
    Rule(" ", " ")
        :with_pair(cond.before_regex("[%(%[{]"))
        :with_pair(cond.after_text("[%)%]}]")),
})
