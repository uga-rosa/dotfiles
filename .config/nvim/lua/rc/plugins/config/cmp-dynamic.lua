local Date = require("cmp_dynamic.utils.date")

require("cmp_dynamic").setup({
    {
        label = "today",
        insertText = 1,
        detail = 1,
        cb = {
            function()
                return os.date("%Y/%m/%d")
            end,
        },
    },
    {
        label = "next Monday",
        insertText = 1,
        detail = 1,
        cb = {
            function()
                return Date.new():add_date(7):day(1):format("%Y/%m/%d")
            end,
        },
    },
    {
        label = "filepath",
        insertText = 1,
        detail = 1,
        cb = {
            function()
                return debug.getinfo(1, "S").source:sub(2)
            end,
        },
    },
})
