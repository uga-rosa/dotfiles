local f = vim.fn
local map = myutils.map

map({ "i", "s" }, "<C-j>", function(fallback)
    if f["vsnip#jumpable"](1) == 1 then
        myutils.feedkey("<Plug>(vsnip-jump-next)", "m")
    else
        fallback()
    end
end)

map({ "i", "s" }, "<C-k>", function(fallback)
    if f["vsnip#jumpable"](-1) == 1 then
        myutils.feedkey("<Plug>(vsnip-jump-prev)", "m")
    else
        fallback()
    end
end)

map("s", "<C-h>", "x<bs>", "noremap")

vim.g.vsnip_snippet_dir = f.stdpath("config") .. "/snippets/json"
vim.g.vsnip_choice_delay = 100
