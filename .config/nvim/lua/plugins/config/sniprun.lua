local map = myutils.map

map("n", "@r", "<Plug>SnipRunOperator")
map("v", "r", "<Plug>SnipRun")

require("sniprun").setup({
    display = {
        "Classic",
    },
})
