local res, npairs = pcall(require, "nvim-autopairs")
if not res then
  return
end

npairs.setup({
  ignored_next_char = string.gsub([[ [%w%%%[%.] ]], "%s+", ""),
})

require("nvim-autopairs.completion.cmp").setup({
  map_cr = true,
  map_complete = true,
  auto_select = true,
})
