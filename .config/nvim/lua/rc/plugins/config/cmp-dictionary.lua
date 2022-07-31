local dict = require("cmp_dictionary")

dict.setup({
    dic = {
        ["autohotkey"] = "~/dotfiles/doc/ahk.dict",
        spelllang = {
            en = "/usr/share/dict/words",
        },
    },
    exact = 2,
    first_case_insensitive = true,
    document = true,
})

-- For lazy loading
dict.update()
