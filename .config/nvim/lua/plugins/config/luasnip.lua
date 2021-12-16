local map = vim_api.map

map({ "i", "s" }, "<C-j>", "<Plug>luasnip-jump-next")
map({ "i", "s" }, "<C-k>", "<Plug>luasnip-jump-prev")

require("luasnip.loaders.from_snipmate").lazy_load()
