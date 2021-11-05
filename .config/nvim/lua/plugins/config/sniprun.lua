require("sniprun").setup({
    display = {
        "NvimNotify",
    },
})

local map = vim_api.map

map("n", "@r", "%SnipRun", "cmd")
map("v", "@r", "<Plug>SnipRun")
