local map = myutils.map

local feedkey = function(key, mode)
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode)
end

map({ "i", "s" }, "<C-j>", function(fallback)
  if vim.fn["vsnip#available"](1) == 1 then
    feedkey("<Plug>(vsnip-jump-next)", "m")
  else
    fallback()
  end
end)

map({ "i", "s" }, "<C-k>", function(fallback)
  if vim.fn["vsnip#available"](-1) == 1 then
    feedkey("<Plug>(vsnip-jump-prev)", "m")
  else
    fallback()
  end
end)

vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/lua/snippets/json"
