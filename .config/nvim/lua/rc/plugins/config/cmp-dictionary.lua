local dict = require("cmp_dictionary")

dict.setup({
    dic = {
        ["autohotkey"] = "~/dotfiles/dict/ahk.dict",
        spelllang = {
            en = "~/.dict/en.dict",
            -- ja = "~/dotfiles/dic/ja.dict",
        },
    },
    exact = 2,
    first_case_insensitive = true,
    document = true,
})

-- For lazy loading
dict.update()
